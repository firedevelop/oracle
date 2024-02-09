#!/bin/bash

# Define an array containing the file names
files=(
    "001_00_Notes.sql"
    "002_00_Anonymous Block.sql"
    "003_00_Data Types.sql"
    "004_00_Variables.sql"
    "005_00_Comments.sql"
    "006_00_Constants.sql"
    "007_00_IF THEN.sql"
    "008_00_CASE.sql"
    "009_00_GOTO.sql"
    "010_00_NULL Statement.sql"
    "011_00_LOOP.sql"
    "012_00_FOR LOOP.sql"
    "013_00_WHILE Loop.sql"
    "014_00_CONTINUE.sql"
    "015_00_SELECT INTO.sql"
    "016_00_Exception.sql"
    "017_00_Exception Propagation.sql"
    "018_00_RAISE Exceptions.sql"
    "019_00_RAISE_APPLICATION_ERROR.sql"
    "020_00_RECORDS.sql"
    "021_00_Cursors.sql"
    "022_00_Cursor FOR LOOP.sql"
    "023_00_Cursors with Parameters.sql"
    "024_00_REF CURSOR.sql"
    "025_00_Updatable Cursors.sql"
    "026_00_Procedure.sql"
    "027_00_Function.sql"
    "028_00_Cursor Variables.sql"
    "029_00_Implicit Statement Results.sql"
    "030_00_Package.sql"
    "031_00_Package Specification.sql"
    "032_00_Package Body.sql"
    "033_00_Triggers.sql"
    "034_00_Statement-level Triggers.sql"
    "035_00_Row-level Triggers.sql"
    "036_00_INSTEAD OF Triggers.sql"
    "037_00_Disable Triggers.sql"
    "038_00_Enable Triggers.sql"
    "039_00_Drop Triggers.sql"
    "040_00_Fixing Mutating Table Error.sql"
    "041_00_Associative Array.sql"
    "042_00_Nested Tables.sql"
    "043_00_VARRAY.sql"
)

# Loop through the array and create the files
for file in "${files[@]}"; do
    touch "$file"
    echo "Created $file"
done