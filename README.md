# Bloom

## Description 

- CIS 4301 Assignment 5
- This is an iOS application that allows you to:
    - Select from a number of flowers and see the last 10 sightings of that flower
    - Insert a new sighting of a flower
    - Update a flower's information

## Team Members
- Steven Hurtado
    - Worked on front-end iOS

- Renzo Rodriguez
    - Worked on back-end PHP & SQL

## Technologies Used

- Languages
   - Swift
   - SQL/SQLite
   - PHP
   
- Libraries/Frameworks
   - Expanding Collection by Ramotion Inc. (iOS)
        - Github Link: https://github.com/ramotion/expanding-collection
   - Slim Framework (PHP)
        - Github Link: https://github.com/slimphp/Slim

## Notes

- SQLite3 file (flowers.db) would not be accepted phpMyAdmin so the file format had to be changed. The following steps were taken:
    1) Upload the flowers.db file to https://sqliteonline.com/
    2) Export each table as a CSV
    3) The exported files' columns were all put into one semi-colon delimited column so the file had to be further modified by:
        1) opening the csv in notepad and adding sep=; at the top of the file and saving it
        2) opening the file in excel and saving the newly parsed file which now has the values in it's respective columns
    4) Importing each of the CSVs and appropriately naming the tables and columns to the original database file's specifications
- The SIGHTED column in the SIGHTINGS table was modified to accept varchar(10) instead of varchar(9) because it would cut off the dates
    - EX: 12/13/2017
- The PHP API for running SQL Queries from Client-Side HTTP Requests is being temporarily being hosted on: https://www.renzojrodriguez.com