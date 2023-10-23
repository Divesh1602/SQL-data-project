# How to run

## SECTION: 1. Create DB, permissions etc.

If you want to create a user having a database and which is the owner of that database also then run the section: 1.

+ Run the commands from point 1-7 one by one.
+ After that you will have a database of yours with your_user as the owner.


## SECTION: 2. Clean up script

If you want to delete the created user and also the database then run the commands in section: 2.

+ Run the commands from point 1-6 one by one.
+ After that you have deleted a database of yours with your_user as the owner and also the your_user.

## SECTION: 3. Load CSV and Solve the IPL problems

### Before running the commands of section 3. Run the following command.
+ Run psql -U <your_username> -d <your_dbname> if you have created your own user.
+ Otherwise run the commands from 1-2 of section 2.


### After that: 
+ The commands from 1-6 will create 3 tables and load the csv data into that file. you should run the commands one by one.
+ If you run the rest of the commands one by one then you will be able to see the data needed by the IPL dataset questions.  

