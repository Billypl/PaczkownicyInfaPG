

[![Stargazers][stars-shield]][stars-url]
[![Forks][forks-shield]][forks-url]
[![Issues][issues-shield]][issues-url]
[![Contributors][contributors-shield]][contributors-url]

# Paczka Updater
[![YouTubeViews][youtube-views-shield]][youtube-url]
[![OfficialDiscord][discord-shield]][discord-url]



Paczka Google Drive: https://drive.google.com/drive/folders/1AMJFl1pLO3EPuq6jlE4fCtxg1V4kvshv?usp=sharing

Paczka Updater - czyli repozytorium na GitHubie, dzięki któremu praca nad paczką jest prostsza niż kiedykolwiek! Ściągnij repo do siebie, wrzuć materiały do folderu [paczka](paczka/) i wystaw pull requesta. Po zatwierdzeniu pliki automatycznie zostaną umieszczone na [google drive](https://drive.google.com/drive/folders/1AMJFl1pLO3EPuq6jlE4fCtxg1V4kvshv?usp=sharing). Dajcie gwiazdkę ⭐ na repozytorium GitHuba, żeby go nie zgubić. Dzięki za kontrybucje i mam nadzieję, że paczka będzie służyć!  

Pozdrawiają,  
*koledzy z poprzednich lat*

![project cover](/docs/glowne_readme/repo_cover.png)

## Paczka Tutorial all-in-one
https://youtu.be/tuTGdGo7trQ
[![Watch the video](https://img.youtube.com/vi/tuTGdGo7trQ/maxresdefault.jpg)](https://youtu.be/tuTGdGo7trQ)




## Ważne!! - przeczytać przed dodawaniem do paczki:

**[Tutorial all-in-one.](https://www.youtube.com/watch?v=tuTGdGo7trQ)** Zachęcam do subskrybcji.  

Przed dodawaniem do paczki przeczytać:
1. [Jak dodawać do paczki?](docs/udzial_w_paczce/udzial_w_paczce.md)  
2. [Wytyczne odnośnie struktury i nazw plików](docs/wytyczne/wytyczne.md)

W skrócie:  
1. Forkujemy repozytorium 
2. Tworzymy nowego brancha  
4. Pliki umieszczamy w `paczka/SEM[NR_SEMA]/NAZWA_PRZEDMIOTU`  
5. Pushujemy pracę na swojego forka
6. Po zakończeniu pracy wystawiamy Pull Request  
7. Po jego zatwierdzeniu i trafieniu do mastera pliki są automatycznie uploadowane do folderu [Google Drive](https://drive.google.com/drive/folders/1AMJFl1pLO3EPuq6jlE4fCtxg1V4kvshv?usp=sharing)  

Nie masz pomysłów, z czym możesz pomóc? Przeglądnij [issues](https://github.com/Billypl/PaczkownicyInfaPG/issues) z przykładowymi pomysłami.  

## Aktualny postęp paczki
Aktualny postęp paczki można zobaczyć w podanych poniżej issuse'ach:
- [ ] [SEM1](https://github.com/Billypl/PaczkownicyInfaPG/issues/20) - x/x
- [ ] [SEM2](https://github.com/Billypl/PaczkownicyInfaPG/issues/21) - x/x
- [ ] [SEM3](https://github.com/Billypl/PaczkownicyInfaPG/issues/22) - x/x
- [ ] [SEM4](https://github.com/Billypl/PaczkownicyInfaPG/issues/23) - x/x
- [ ] [SEM5](https://github.com/Billypl/PaczkownicyInfaPG/issues/24) - x/x
- [ ] [SEM6](https://github.com/Billypl/PaczkownicyInfaPG/issues/25) - x/x
- [ ] [SEM7](https://github.com/Billypl/PaczkownicyInfaPG/issues/26) - x/x

## Uwagi
- Przeczytać [wytyczne](/docs/wytyczne/wytyczne.md)! To jest bardzo ważne w celu minimalizacji poprawek!!
- Puste foldery działają jak w githubie (nie są przesyłane). Jeżeli chcecie wysłać pusty folder, to stwórzcie plik ".gitkeep". Zostanie on usunięty automatycznie przed uploadem na gdrive.  
- Odchudzić foldery ze wszystkich plików *.bin, *.exe etc. - w celu ułatwienia tego został stworzony [gitignore-generator](utility/gitignore-generator.sh) ([link do oficjalnego repo](https://github.com/Billypl/GitignoreGenerator)) do znalezienia w folderze [utility](utlility/). W celu zapoznania się z działaniem należy użyć flagi -h. Skrypt pozwala na szybkie generowanie .gitignore'ów łączących różne technologie. Tak wygenerowany .gitignore należy umieścić w **folderze projektu** (nie w głównym .gitignore repo), który jest wrzucany do paczki, aby uniknąć wrzucania niepotrzebnych plików. **W takim wypadku nie trzeba niczego usuwać ręcznie ze swojego dysku.**  
- Folder **Stara Paczka** służy tylko na **NIEAKTUALNE** materiały (np. zmieniła się forma / prowadzący)  

## Użyte projekty
- https://github.com/Billypl/GithubGDriveSync
- https://github.com/Billypl/GitignoreGenerator
- https://gist.github.com/jagrosh/5b1761213e33fc5b54ec7f6379034a22
- https://github.com/SilasRodrigues19/Portfolio/blob/main/README.md
- https://shields.io/badges/

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/Billypl/PaczkownicyInfaPG.svg?style=for-the-badge
[contributors-url]: https://github.com/Billypl/PaczkownicyInfaPG/graphs/contributors

[forks-shield]: https://img.shields.io/github/forks/Billypl/PaczkownicyInfaPG?style=for-the-badge
[forks-url]: https://github.com/Billypl/PaczkownicyInfaPG/network/members

[stars-shield]: https://img.shields.io/github/stars/Billypl/PaczkownicyInfaPG?style=for-the-badge
[stars-url]: https://github.com/Billypl/PaczkownicyInfaPG/stargazers

[issues-shield]: https://img.shields.io/github/issues/Billypl/PaczkownicyInfaPG.svg?style=for-the-badge
[issues-url]: https://github.com/Billypl/PaczkownicyInfaPG/issues

[youtube-views-shield]: https://img.shields.io/youtube/views/tuTGdGo7trQ?style=for-the-badge&logo=youtube&logoColor=red&label=tutorial%20views
[youtube-url]: https://youtu.be/tuTGdGo7trQ?si=UmZ2PyprnpxvG76_

[discord-shield]: https://img.shields.io/badge/official_discord-join-%235865F2?style=for-the-badge&logo=discord&logoColor=%235865F2&color=%235865F2
[discord-url]: https://discord.gg/8MVeYzChkT  

<br><hr>
[🔼 Back to top](#paczka-updater)