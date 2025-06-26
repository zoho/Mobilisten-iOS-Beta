#!/bin/bash

# Script to compute checksums for all ZIP files in current directory
# Usage: ./compute-checksums.sh
# Output: checksums.txt

OUTPUT_FILE="checksums.txt"

# Clear the output file
> "$OUTPUT_FILE"

echo "Computing checksums for all ZIP files in current directory..."
echo "Output will be saved to: $OUTPUT_FILE"
echo "=================================================="

# Write header to file
{
    echo "ZIP File Checksums"
    echo "Generated on: $(date)"
    echo "Directory: $(pwd)"
    echo "=================================================="
    echo ""
} >> "$OUTPUT_FILE"

# Check if swift package command is available
if ! command -v swift &> /dev/null; then
    echo "Error: Swift is not installed or not in PATH"
    echo "Error: Swift is not installed or not in PATH" >> "$OUTPUT_FILE"
    exit 1
fi

# Find all ZIP files and compute checksums
found_zips=false

for zip_file in *.zip; do
    # Check if the glob matched any files
    if [[ ! -e "$zip_file" ]]; then
        continue
    fi
    
    found_zips=true
    echo "Processing: $zip_file"
    
    # Compute checksum using swift package
    checksum=$(swift package compute-checksum "$zip_file" 2>&1)
    
    # Check if command was successful
    if [[ $? -eq 0 ]]; then
        echo "✅ $zip_file"
        echo "   Checksum: $checksum"
        echo ""
        
        # Write to file
        {
            echo "File: $zip_file"
            echo "Checksum: $checksum"
            echo ""
        } >> "$OUTPUT_FILE"
    else
        echo "❌ Failed to compute checksum for $zip_file"
        echo "   Error: $checksum"
        echo ""
        
        # Write error to file
        {
            echo "File: $zip_file"
            echo "ERROR: Failed to compute checksum"
            echo "Details: $checksum"
            echo ""
        } >> "$OUTPUT_FILE"
    fi
done

if [[ "$found_zips" == false ]]; then
    echo "No ZIP files found in current directory."
    echo "Current directory: $(pwd)"
    echo "Files present:"
    ls -la
    
    # Write to file
    {
        echo "No ZIP files found in current directory."
        echo ""
        echo "Files present:"
        ls -la
    } >> "$OUTPUT_FILE"
fi

echo "=================================================="
echo "Checksum computation completed!"
echo "Results saved to: $OUTPUT_FILE"

# Write footer to file
{
    echo "=================================================="
    echo "Checksum computation completed at: $(date)"
} >> "$OUTPUT_FILE"