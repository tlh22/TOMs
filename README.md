
# **TOMs (Traffic Order Management System)**

**Table of Contents:**
1. [Introduction](##introduction)
2. [Concepts](##concepts)
3. [Installation](##installation)

    3.1 [QGIS](###qgis)
    
    3.2 [postgresql](###postgresql)
    
    3.3 [QGIS-Server](###qgis-server)
4. [Usage](##usage)
5. [Contributing](##contributing)
6. [Credits](##credits)
6. [License](##license)

<a name="introduction"/></a>
## **Introduction** 

TOMs is a system for managing map based traffic orders. It is developed for use by local authorities in the UK - although the principles are applicable for any country.


TOMs provides users with the facility to:
 - view the current and proposed restrictions as at a given date
 - manage restrictions, i.e., create, edit and delete restrictions
 - print existing or proposed restriction details as at a given date

<a name="concepts"></a>
## **Concepts** 

TOMs has the following key concepts:


a. Restriction. This is the lines and signs that exist on street. These are grouped into:
 - Bays
 - Lines
 - Signs
 - Polygon Restrictions, e.g., parking permit areas
 - Zones such as Controlled Parking Zones (CPZs) and Parking Tariff Areas (PTAs)

The geometry of a restriction is held against the kerbline. TOMs provides for a range of different styles for representing restrictions, e.g., bays may be displayed as lines or polygons.


b. Proposal. This groups changes to restrictions and manages the acceptance process. Typcially, these would be put to public consultation. If they are accepted, the changes would be made together on a given date.

c. Open/Close date. This is the date at which a Proposal is accepted and changes are made to the restrictions

d. Map Tiles. A map tile is versioned according to the open/close date for any restrictions it contains. 

<a name="installation"></a>
## **Installation** 

### **QGIS** <a name="qgis"></a>

TOMs is a python plugin that makes use of and extends tools within QGIS. TOMs follows the LTR (Long Term Release) of QGIS. 

The current version of TOMs is available here - https://github.com/opengisch/TOMs/releases. As with any QGIS plugins, place the downloaded files into a folder that is accessible on PYTHONPATH. 

It relies on a connection to a postgres/postgis database. See below for details of the data structure.


### **postgresql** <a name="postgresql"></a>
TOMs assumes a connection to a postgres database that has the postgis and uuid-ossp extensions installed. (The python extention will be in use soon). Installers for different platforms are available here - https://www.postgresql.org/download/.

There are a series of scripts to create the database structure that are found in the DATAMODEL folder

Scripts for populating a test database can be found within the test/data folder.
 
There are three roles within the test database
- toms_admin – with ability to accept/reject proposals, update restrictions in use …
- toms_operator – ability to create proposal and make changes within a proposal
- toms_public – read access

Users are then assigned to one of these roles. There are three users that have been created for the test environment:
- test_toms_admin with password “password”
- test_toms_operator with password “password”
- test_toms_public with password “password”

The test project file is found within the QGIS folder. This project file uses a postgres service to access the database. (See https://www.postgresql.org/docs/9.1/libpq-pgservice.html)

### **QGIS-Server** <a name="qgis-server"></a>

The test project file sets capabilities for WMS and WFS services.

< Further details required here >

## **Usage** <a name="usage"></a>
### Video

[![TOMs](https://img.youtube.com/vi/_sG7226QziE/0.jpg)](https://www.youtube.com/watch?v=_sG7226QziE)

< This video was the original concept. More details required here >

## **Contributing** <a name="contributing"></a>
Contributions are welcome - whether it be coding, documenting or moral support!. If you are willing/able to assist, please contact the developer(s) to discuss things further.

## **Credits** <a name="credits"></a>
The development is carried out by MHTC Ltd. On-going support has been provided by ProjectCentre Ltd. Guidance and advice has been given by OpenGIS.ch.

## **License** <a name="license"></a>
GNU GPLv3

Git revision : $Format:%H$


## Setting up the database

Using Docker

```bash
# Start a postgis database
docker run --name toms_postgis -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgis/postgis:12-2.5
# Install the plpython extension
docker exec toms_postgis bash -c 'apt-get update && apt-get install -y postgresql-plpython3-$PG_MAJOR'
# Prepare roles
docker exec toms_postgis psql -U postgres -c "
CREATE ROLE toms_admin NOLOGIN;
CREATE ROLE toms_operator NOLOGIN;
CREATE ROLE toms_public NOLOGIN;
"

# Create the datamodel (initial)
cat ./DATAMODEL/0001_initial_data_structure.sql | docker exec -i toms_postgis psql -U postgres

# Import the data
cat ./test/data/0002a_test_data_lookups.sql | docker exec -i toms_postgis psql -U postgres
cat ./test/data/0002b1_test_data_main.sql | docker exec -i toms_postgis psql -U postgres
cat ./test/data/0002b2_test_data_main.sql | docker exec -i toms_postgis psql -U postgres

# Run the other migrations
cat ./DATAMODEL/0002_permissions.sql | docker exec -i toms_postgis psql -U postgres
cat ./DATAMODEL/0003_refresh_materialized_views.sql | docker exec -i toms_postgis psql -U postgres
cat ./DATAMODEL/0004_labels-multipoints.sql | docker exec -i toms_postgis psql -U postgres
```