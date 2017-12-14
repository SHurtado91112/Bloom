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

## GIF
### Showing all queried flowers
![demo_show_all](https://user-images.githubusercontent.com/11231583/33969846-dc2998b4-e03d-11e7-933b-673b3297bed8.gif)

### Showing all queried sightings and insert/update functionality
![demo_all_sightings](https://user-images.githubusercontent.com/11231583/33969859-f5193d34-e03d-11e7-9d36-1bb132d16c93.gif)

## Screenshots
### Query Info for Flower
![select_query_flower](https://user-images.githubusercontent.com/11231583/33969925-49efb0d6-e03e-11e7-934f-924142eee086.jpeg)

### Query of Sightings per Flower
![select_query_sightings](https://user-images.githubusercontent.com/11231583/33969935-5c22782e-e03e-11e7-9f63-21eba3d7278f.jpeg)

### Insert Sighting
![insert_sighting_1](https://user-images.githubusercontent.com/11231583/33969960-7f13ca54-e03e-11e7-923f-ba94c4782669.jpeg)
![insert_sighting_2](https://user-images.githubusercontent.com/11231583/33969965-81444f42-e03e-11e7-929d-986d2c644687.jpeg)

### Update Sighting
![update_sighting_1](https://user-images.githubusercontent.com/11231583/33969987-9dae273e-e03e-11e7-8804-ff016751a52f.jpeg)
![update_sighting_2](https://user-images.githubusercontent.com/11231583/33969990-9eed7db6-e03e-11e7-949e-275779c1916e.jpeg)


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
