#!/bin/bash
#sh get-bibs.sh

#!/bin/bash

# Define an array of directories containing TeX files
directories=(
    "syllabus"
    "homework-1"
    "homework-2"
    "homework-3"
)

# Let's instead just add all directories, assuming that there is a latex file in each
#directories=($(find ./ -type d))

# Iterate through each directory
for dir in "${directories[@]}"; do
    echo "Processing directory: $dir"
    
    # Change to the directory
    cd "$dir" || { echo "Failed to enter directory $dir"; continue; }
    echo "Current Directory: $(pwd)"

    # Compile each .tex file
    for tex_file in *.tex; do
        if [[ -f "$tex_file" ]]; then
            echo "Running LaTeX on $tex_file"
            # I generally don't want author names to be saved forever in my main dictionary file.  So, instead, let's use a project specific personal dictionary file.
            aspell check -p ./dict.txt "$tex_file"
            latex "$tex_file" && dvips "${tex_file%.tex}.dvi" -o "${tex_file%.tex}.ps"
            # and run twice more to make sure that refs generate correctly
            latex "$tex_file" && dvips "${tex_file%.tex}.dvi" -o "${tex_file%.tex}.ps"
            latex "$tex_file" && dvips "${tex_file%.tex}.dvi" -o "${tex_file%.tex}.ps"
            ps2pdf "${tex_file%.tex}.ps" "${tex_file%.tex}.pdf"
            
            # Move PDFs to the appropriate folder
            echo "PDFs created in $dir:"
            ls -1 *.pdf
            mv *.pdf ../../
            echo "PDF moved to the root git directory."
            
            # Clean up intermediate files
            echo "Cleaning up intermediate files for $tex_file"
            rm -f "${tex_file%.tex}.dvi" "${tex_file%.tex}.ps"
        else
            echo "No .tex files found in $dir"
        fi
    done

    echo "Finished processing directory: $dir"
    echo "---------------------------------------"
    cd ../
done

echo "All directories processed."
