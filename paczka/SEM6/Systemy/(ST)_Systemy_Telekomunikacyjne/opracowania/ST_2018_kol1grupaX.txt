# ST - Kolokwium 1

Definicje:
- **Telekomunikacja to nauka o przekazywaniu wiadomości na odległość przez sygnały.**
- Usługa Telekomunikacyjna - usługa świadczona każdorazowo przez telekomunikację na rzecz i żądanie użytkowników (poprzez urządzenia i organizację telekomunikacji).
- Połączenie (telekomunikacyjne) - stan określonych urządzeń umożliwiający świadczenie usługi.
- Komutacja - proces polegający na tworzeniu połączenia telekomunikacyjnego, a następnie likwidacji połączenia, do dyspozycji użytkowników lub programów.

Historia:
- Pierwsza rozmowa telefoniczna: 1876.
- Pierwsza centrala automatyczna: 1892 (USA)
- Rewolucję w rozwoju środków realizacji telekomunikacji dokonało odkrycie **elektryczności**.
- Wynalezienie **tranzystora** pozwoliło na rozpoczęcie prac nad centralami elektronicznymi.
- Wprowadzenie **ukladów scalonych TTL** znacznie to przyspieszyło.

Skróty:
- AC: Admission Control (funkcja, która w oparciu o kontrakt i stan zasobów określa możliwość realizacji tego kontraktu oraz określa co można zapewnić użytkownikowi).
- CC: Call Control (tu jest algorytm zarządzania między węzłami).
- CBR/VBR: Constant/Variable Bit Rate.
- ATM/STM: Asynchronous/Synchronous Transfer Mode.

Random:
- Liczba bitów między CC w stosunku do warstwy łącza sygnalizacyjnego jest **mniejsza**.
- Jednostki charakteryzujące linię długą: Indukcyjność, pojemność, rezystancja, konduktancja.
- S/N (SNR): Signal-Noise Ratio, stosunek mocy sygnału do mocy szumu i zakłóceń.
- **Dyspersja** głównie wpływa na zasięg transmisji.
- Echo występuje **w rozgałęźniku**.
- Przepływność jest dla technik cyfrowych, pasmo dla analogowych.
- Przenik - zakłócenie sygnału (polega na przenikaniu energii sygnału z jego drogi przesyłowej do dróg przesyłowych innych sygnałów), dzieli się na przenik zbliżny/zdalny. Przenik zbliżny znacznie obniza zasięg transmisji.
- Przy przenoszeniu sygnałów/informacji staramy się zachować **kształt**.
- Technika **analogowa przesyła więcej** informacji.
- BER (Bit Error Rate) - elementowa stopa błędów. Określia prawdopodobieństwo wystąpienia błędu przy określonym SNR (dlatego zawsze przy BER podaje się też SNR).
- Kanał to łącze jednokierunkowe.
- Funkcja łączenia jest w komutacji kanałów.
- Relacja: Łącze **zawiera się** w systemie transmisyjnym.
- Relacja: Prepustowość łącza jest **większa lub równa** prędkości nadawania.
- Multipleksacja pozwala na lepsze wykorzystanie zasobów (została wprowadzona aby zminimalizować koszt).
- Technika cyfrowa pozwala na większy stosunek sygnałów do szumów.
- Abonent jest zainteresowany dostępnością do usługi, jakością realizacji, kosztem i zakresem usług.
- Operator jest zainteresowany przede wszystkim zyskiem.
- Odbiór sygnału cyfrowego odbywa się wg zegara **lokalnego strony nadającej**.
- TDM(A): Time Division Multiplexing (Access)
- FDM(A): Frequency Division Multiplexing (Access)
- Funkcja łączenia jest: w komutacji kanałów.
- Sygnal podlega zniekształceniom podczas transmisji, co ogranicza zasięg transmisji.
- Tłumienność sygnału dla skrętki w funkcji częstotliwości sygnału jest **rosnąca**.
- Sieć telekomunikacyjna w Polsce ma strukturę **hierarchiczną**.
- Kodowanie 2B1Q koduje 2 bity sygnału w 1 sygnał liniowy o 4 poziomach (co powiększa pasmo).
- Podstawowe funkcje sieci telekomunikacyjnej: Transmisja, komutacja.
- Wiadomość **IAM** zawiera informację o adresie żądanego abonenta i atrybuty usługi.
- Sieć w której muszą mieć miejsce fazy zgłoszenia, połączenia i rozłączenia jest siecią **połączeniową**.
- Protokół dotyczy zasad komunikacji między **odpowiadającymi sobie warstwami dwóch połączonych ze sobą urządzeń**.
- Szerokość pasma kanału analogowego musi być **większa lub równa** szerokości widma sygnału przechodzącego przez ten kanał.
- Parametry charakteryzujące prowadnicę falową: Stała tłumienia i stała fazowa.
- Parametry charakteryzujące kanał: Szerokość pasma przenoszenia, stosunek SNR, stopa błędów BER.
- 3 parametry charakteryzujące otoczenie kanału: Zakłocenia, przesłuch, wielotorowość.
- Przepływność binarna Rb i szybkość modulacji Rm w przypadku stosownania jako medium pary kablowej/światłowodu jest **różna**.
- Zmiany amplitudy napięcia wzdłuż linii długiej mają charakter **wykładniczy**.
- Dwa skrajne sposoby pozyskiwania informacji potrzebnych do sterowania połączeniem: Localnie, centralnie.
- Rb to szybkość transmisji (przepływność strumienia bitów), Rm to szybkość modulacji (ile symboli jest nadawanych w jednostce czasu). Rb = Rm * ilość bitów na symbol.
- Podstawowa cecha dynamicznej metody określania trasy dróg połączeniowych: Branie pod uwagę aktualnego stanu sieci (=> maksymalizacja wykorzystania zasobów).
- Dlaczego występują małe, kontrolowane opóźnienia w dostarczaniu wiadomości: Bo wykorzystywany system sygnalizacji ma charakter systemu czasu rzeczywistego.
- Zjawisko **addytywności zakłóceń i szumów** jest czynnikiem ograniczającym długość połączenia w systemach zrealizowanych w technice analogowej.
- **Parametry sygnału 0dBm** to U = 775mV, I = 1.29mA, P = 1mW, R = 600Ohm.
- Γ to współczynnik odbicia.
- Cyfryzacja abonenckiej linii analogowej wprowadziła w niej kanały **2B + D**.
- Modulację pasmową od modulacji dolnopasmowej nazywanej też kodowaniem transmisyjnym lub kodowaniem liniowym, w sposób istotny różni brak sygnału częstotliwości nośnej? **Nie.**
- Powiązane operacje do elementów: Węzeł - przetwarzanie, łącze - przepływność.
- Dolne ograniczenie STM: 64kbit/s
- **5 elementów funkcjonalnych węzła komutacyjnego (sieć połączeniowa)**: Moduł zakończeń linii abonenckich,, Moduł zakończeń linii międzywęzłowych,, Pole komutacyjne,, Blok sterowania,, Blok sygnalizacji międzywęzłowej.
- **Cztery poziomy hierarchicznej struktury sterowania w węźle komutacyjnym**: Sterowanie węzła, Sterowanie modułów, Sterowanie pakietów, Procesory sygnałowe DSP.
- **Części numeru abonenta w poprzedniej numeracji**: Numer miejscowy, wskaźnik międzystrefowy, wskaźnik krajowy.
- W poprzedniej numeracji prefiks operatora międzymiastowego **nie należał** do numeru abonenta.
- Płaszczyzny klasycznej sieci telekomunikacyjnej: Miejscowa, Międzymiastowa, Międzynarodowa.
- Cechy uwzględniane przy realizacji wyboru drogi połączeniowej/wchodzące w skład metryki: Szerokość pasma, Liczba przeskoków, Obciążenie.
- Integracja technik: Funkcja komutacji i transmisji jest realizowana w oparciu o tą samą technikę, cyfrową (zintegrowana sieć cyfrowa ISDN).
- PSTN świadczy tylko jedną usługę (telefonia/mowa).
- BA (Basic Access): Kanały 2B+D (2B = przepływność 64kbit/s na kanał, dodatkowo 1D na sygnalizację o przepływności 16kbit/s).
- Dlaczego zrezygnowano z ATM i wprowadzono IP: Świat internetu dorzucił technologię ATM uważając, że jest ona obciążona cechami telekomunikacji z rodowodem „mowy” […] docelowa sieć Internetu […] musi być przed wszystkim dostosowana do swoich potrzeb i w jej ramach także obsłużyć „mowę”, a nie odwrotnie.

Rodzaje mediów transmisyjnych:
- Para symetryczna (dwa równoległe przewody)
- skrętka (dwa izolowane przewody skręcone w odpowiedni sposób)
- kabel współosiowy (jeden przewód dokładnie otoczony przez izolowany drugi przewód)
- falowód (metalowa rura o różnych przekrojach)
- światłowód (nic z kwarcu z domieszkami)
- wolna przestrzeń (fale radiowe).

Światłowód:
- Średnica rdzenia: 50, 62.5 lub 120 μm dla wielomodowych, 8-10 μm dla jednomodowych.
- Prowadnica zamknięta - taka która jest odizolowana od otaczającej jej przestrzeni.
- W trzecim oknie światłowodu jest najmniejsza tłumienność (ok. 0.2dB/km).
- Głównie **dyspersja** ma wpływ na zasięg transmisji.
- Wykorzystuje zjawisko **całkowitego odbicia**.

Łącza U/S/T:
- U: 1 para przewodów
- S: 2 pary przewodów, do 8 terminali na styk.
- T: 2 pary przewodów

SDH/STM:
- Długość ramki SDH: 125μs.
- Czas trwania bitu w systemie SDH 155Mbit, STM-256: (1 / (155 * 100^6)) * (1 / 256) = 25ps.
- Światłowód w systemie SDH, STM-256, 80 długości fal, przepustowość: 155Mbit/s (przepustowość STM-1) * 256 (STM-256) * 80 (długości fal) = ok. 3.174Tb/s

PCM30/32:
- Przepływność 1 strumienia binarnego: 64kbit/s.
- 32 szczeliny w ramce, długość pełnej ramki: 125μs.
- Maksymalnie 30 łączy abonenckich + 1 na sygnalizację + 1 na synchronizację.
- Szybkość modulacji z kodowaniem HDB3: 2Mb/s.
- Na medium miedzianym: 2 pary przewodów.
- Kodowanie źródłowe sygnału mowy jest: Nieliniowe o 7 segmentach liniowych.

ATM (Asynchronous Transfer Mode):
- Sieć zorientowana połączeniowo.
- Komórka: 53 bajty (5b nagłówka + 48b informacji)
- Nagłówek jest chroniony przed uszkodzeniem.
- Źródła ruchu: CBR (stały strumień bitów)/VBR (zmienny).
- Istotą jest dopasowanie do źródła (async. dla async. źródła, sync. dla sync. źródła).

Rodzaje połączeń realizowanych przez węzeł komutacyjny:
- Lokalne (lokalny abonent -> lokalny abonent)
- Wychodzące (lokalny abonent -> inny węzeł)
- Przychodzące tranzytowe (inny węzeł -> inny węzeł)
- Przychodzące końcowe (inny węzeł -> lokalny abonent)

Pożądane cechy kodowania liniowego:
- Brak składowej stałej.
- Widmo sygnału liniowego ma jak najwęższe pasmo.
- W odbiorniku powinna być łatwa możliwość odtworzenia sygnału zegarowego.

Obliczenia:
- Liczba kanałów radiowych K wynosi 35, utworzono z nich 7 wiązek kanałów. Wówczas liczba komórek w grupie komórek wynosi 6, a liczba kanałów w komórce wynosi 5.
- K = 70, 7 wiązek kanałów - mamy tyle grup komórek co wiązek kanałów, a liczba kanałów to K / ilość wiązek kanałów.
- Obliczyć przepływność strumienia binarnego dla PCM30/32: Rb = (8000 próbek/s) * 8b = 64Kb/s. (8000 próbek wynika z tw. Nyquista - częstosliwość próbkowania musi wynosić min. 2x najwyższą możliwą amplitudę w Hercach dla PCM30/32.)
- Neper [N] i decybel [dB] to jednostki logarytmiczne określające tłumienie. W Neperach obliczane jako A = ln(U2/U1) [N], w decybelach A = 20log(U2/U1) [dB].
- Wzór do tw. Shannona: C = B * log2[1 + (S / N)] [bit/s], gdzie C - przepływność kanału, B - pasmo przenoszenia, S - sygnał użyteczny, N - szum i zakłócenia.
- Jeśli S/N wynosi 20dB a moc sygnału 1mW, oblicz moc zakłóceń: S/N = 20dB = 10log(P1/P2) -> 1mW/P2 = 100 -> P2 = 1mW/100 = 0.01mW.

(Dense) Wavelength Division Multiplexing (DWDM):
- WDM wprowadza do 8 długości fal, DWDM (Dense WDM) do 320.
- DWDM wymaga regeneratorów gdyż ze względu na dyspersję sygnał po pewnym czasie staje się zniekształcony i trzeba przywrócić odpowiedni kształt (zwykle już po wzmocnieniu sygnału).
- Osiągana odległość między wzmacniaczami optycznymi w DWDM: 100-200km.

System Wymiany Informacji (SIW):
- Jest siecią telekomunikacyjną.
- **Terminal** separuje abonenta od SIW.
- Kto bierze udział w tworzeniu SIW: Ośrodki R&D, firmy konstrukcyjno-produkcyjne, operatorzy telekomunikacyjni.

Sieci połączeniowe/bezpołączeniowe:
- Sieci mogą być zorientowane **połączeniowo lub bezpołączeniowo**.
- Sieć sygnalizacyjna jest siecią **bezpołączeniową**.
- Cechy sieci bezpołączeniowej: Buforowanie wiadomości, brak sygnalizacji (rezerwacji zasobów).
- Cechy sieci połączeniowej: Rezerwacja zasobów (łączy), brak buforowania wiadomości, obsługa abonenta w 3 fazach (rezerw. zasobów, przesył informacji, zwolnienie zasobów).
