#!/bin/bash

input_file="struktura.csv"
output_file="subjects_formatted.txt"

# Clear the output file
> "$output_file"

# Download the CSV 
url="https://ects.pg.edu.pl/pl/courses/15450/plan.xls"
tmp_xls="struktura.xls"
tmp_csv="struktura.csv"
echo "Downloading data from $url..." && \
curl -s "$url" > "$tmp_xls" && \
echo "Converting XLS to CSV..." && \
ssconvert -S $tmp_xls $tmp_csv  2>/dev/null && \
mv $tmp_csv."0" $tmp_csv && \
rm $tmp_xls

echo "Processing data from CSV..."
awk -v FPAT='[^,]*|"[^"]+"' '
BEGIN {
    current_semester = ""
    current_stream = ""
    current_profile = ""
    OFS=""
    indent = "  "
}

# Capture semester headers
/^"SEMESTR [0-9]"/ {
    current_semester = $0
    gsub(/"/, "", current_semester) # Remove quotes
    gsub(/,+/, "", current_semester) # Remove commas
    current_stream = ""
    current_profile = ""
    print "\n" current_semester >> "'"$output_file"'"
    next
}

# Capture stream headers
/^"[0-9] [^"]+ \(Strumień\)"/ {
    current_stream = $0
    gsub(/"/, "", current_stream)        # Remove quotes
    gsub(/^[0-9]+ /, "", current_stream) # Remove number from beginning
    gsub(/,+/, "", current_stream)       # Remove commas
    current_profile = ""
    print indent current_stream >> "'"$output_file"'"
    next
}

# Capture profile headers
/^"[0-9] [^"]+ \(Profil\)"/ {
    current_profile = $0
    gsub(/"/, "", current_profile)
    gsub(/^[0-9]+ /, "", current_profile) # Remove number from beginning
    gsub(/,+/, "", current_profile)       # Remove commas
    print indent indent current_profile >> "'"$output_file"'"
    next
}

/^[0-9]+,/ {
    # Skip if not in a semester
    if (current_semester == "") next
    
    # Extract and format subject name
    gsub(/"/, "", $4)
    subject = $4
    
    # Create acronym
    acronym = ""
    split(subject, words, " ")
    for (i in words) {
        first_char = toupper(substr(words[i], 1, 1))
        acronym = acronym first_char
    }
    
    # Format full name
    formatted_name = ""
    for (i in words) {
        if (i > 1) formatted_name = formatted_name "_"
        word = words[i]
        first_char = toupper(substr(word, 1, 1))
        rest = substr(word, 2)
        formatted_name = formatted_name first_char rest
    }
    
    # Extract hours
    lecture = $8
    exercises = $9
    lab = $10
    project = $11
    seminar = $12
    
    # Build class types
    class_types = ""
    if (lecture > 0) class_types = class_types "W "
    if (exercises > 0) class_types = class_types "C "
    if (lab > 0) class_types = class_types "L "
    if (project > 0) class_types = class_types "P "
    if (seminar > 0) class_types = class_types "S"
    sub(/ $/, "", class_types)
    
    # Determine indentation level
    current_indent = indent
    if (current_profile != "") {
        current_indent = indent indent indent
    } else if (current_stream != "") {
        current_indent = indent indent
    }
    
    # Print course
    printf "%s(%s)_%s: %s\n", current_indent, acronym, formatted_name, class_types >> "'"$output_file"'"
}' "$input_file"

rm $input_file
echo "Data has been saved to $output_file!"