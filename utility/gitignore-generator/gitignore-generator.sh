#!/bin/bash
# todo - add ignore letter case

GITHUB_REPO="https://raw.githubusercontent.com/github/gitignore/main"
TEMP_FILE=".gitignore.temp"
OUTPUT_FILE=".gitignore"

declare -A OPTIONS=(
  [1]="___PROGRAMMING LANGUAGES___"
  [2]="Ada"
  [3]="Angular"
  [4]="C"
  [5]="C++"
  [6]="CMake"
  [7]="CUDA"
  [8]="Dotnet"
  [9]="Gradel"
  [10]="Global/GPG"
  [11]="Haskell"
  [12]="Java"
  [13]="Kotlin"
  [14]="Node"
  [15]="Global/MATLAB"
  [16]="Objective-C"
  [17]="Prestashop"
  [18]="Python"
  [19]="R"
  [20]="Smalltalk"
  [21]="Swift"
  [22]="TeX"
  [23]="Unity"
  [24]="UnrealEngine"
  [25]="VBA"
  [26]="___EDITORS___"
  [27]="VisualStudio"
  [28]="Global/VisualStudioCode"
  [29]="Global/JetBrains"
  [30]="Global/Vim"
  [31]="Global/Eclipse"
  [32]="Global/Emacs"
  [33]="Global/SublimeText"
  [34]="Global/Xcode"
  [35]="___OS___"
  [36]="Global/Linux"
  [37]="Global/Windows"
  [38]="Global/macOS"
  [39]="___OTHER___"
  [40]="Global/Images"
)

show_help() {
    echo "Usage: $0 [options] [<Tech1> <Tech2> ...]"
    echo
    echo "Options:"
    echo "  -h, --help          Show this help message and exit"
    echo "  -l, --list          List most used PG .gitignore templates"
    echo "  -a, --all           List all available .gitignore templates"
    echo
    echo "Description:"
    echo "  This script allows you to generate a .gitignore file based on selected"
    echo "  programming languages, IDEs, operating systems, and other common ignore rules."
    echo
    echo "  You can run the script interactively (menu will be shown), or pass technologies"
    echo "  directly as arguments to create the .gitignore file automatically."
    echo
    echo "Examples:"
    echo "  $0                  # Run in interactive mode (menu)"
    echo "  $0 Python VSCode    # Create a .gitignore for Python and VSCode"
    echo "  $0 Java Node Docker # Create a .gitignore for Java, Node, and Docker"
    echo "  $0 -a               # Fetch all aviable .gitignore files"
    echo "  $0 -l               # Fetch .gitignore files for most used languages on PG"
    echo
    echo "Supported templates are fetched from:"
    echo "  https://github.com/github/gitignore"
    echo
    echo "Use \"$0 --list\" to see the available templates."
}


list_templates_from_github() {
    echo "Fetching available templates..."
    echo "######## MAIN TEMPLATES ########"
    curl -s https://api.github.com/repos/github/gitignore/contents/ | \
        grep '"name":' | \
        grep -E '\.gitignore' | \
        sed -E 's/.*"([^"]+)\.gitignore".*/\1/' | \
        sort

    echo "######## OTHER TEMPLATES ########"
    curl -s https://api.github.com/repos/github/gitignore/contents/Global | \
        grep '"name":' | \
        grep -E '\.gitignore' | \
        sed -E 's/.*"([^"]+)\.gitignore".*/\1/' | \
        sort
    
}

list_options() {
    for i in $(printf "%s\n" "${!OPTIONS[@]}" | sort -n); do
        printf "%2d) %s\n" "$i" "${OPTIONS[$i]}"
    done
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
elif [[ "$1" == "-a" || "$1" == "--all" ]]; then
    list_templates_from_github | column
    exit 0
elif [[ "$1" == "-l" || "$1" == "--list" ]]; then
    list_options | column
    exit 0
fi

function download_gitignore() {
    local name="$1"
    local url="$GITHUB_REPO/${name}.gitignore"

    echo "🌍 Downloading ${name}.gitignore..."
    echo -e "\n# --------- ${name}.gitignore starts here ---------\n" >> "$TEMP_FILE"
    if curl -fsSL "$url" >> "$TEMP_FILE"; then
        echo -e "\n# --------- ${name}.gitignore ends here ---------\n" >> "$TEMP_FILE"
    else
        echo "⚠️  Error downloading: $name"
    fi
}

# Wyczyść lub stwórz plik tymczasowy
> "$TEMP_FILE"

if [ "$#" -gt 0 ]; then
    # Tryb bez interakcji — użyj podanych argumentów jako nazw
    for arg in "$@"; do
        download_gitignore "$arg"
    done
else
    # Tryb interaktywny
    echo "🔧 Choose components to be added to .gitignore (SPACE = choice, ENTER = end):"


    read -p "Enter numbers separated by SPACE: " -a SELECTION

    for index in "${SELECTION[@]}"; do
        OPTION="${OPTIONS[$index]}"
        if [[ -n "$OPTION" && "$OPTION" != \#* ]]; then
            download_gitignore "$OPTION"
        else
            echo "⚠️  Invalid or skipped option: $index"
        fi
    done
fi

mv "$TEMP_FILE" "$OUTPUT_FILE"
echo "✅ Generated $OUTPUT_FILE from provided components."
