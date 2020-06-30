
###### **TOMs (Traffic Order Management System)**

**Introduction**

TOMs is a system for managing map based traffic orders. It is developed for use by local authorities in the UK - although the principles are applicable for any country.

TOMs provides users with the facility to:
 - view the current and proposed restrictions as at a given date
 - manage restrictions, i.e., create, edit and delete restrictions
 - print existing or proposed restriction details as at a given date

**Concepts**

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

**System structure**

TOMs is a python plugin that makes use of and extends tools within QGIS.  

It relies on a connection to a postgres/postgis database. Details of the data structure can be found in the wiki.


**Installation**

TOMs follows the LTR (Long Term Release) of QGIS. The current version is available here - https://github.com/opengisch/TOMs/releases. As with any plugins, place the downloaded files into a folder that is accessible on PYTHONPATH. 

**Pre-requisites**

TOMs assumes a connection to a postgres database with the postgis and uuid-ossp extensions. (The python extention will be in use soon). Installers for different platforms are available here - https://www.postgresql.org/download/.

There are a series of scripts to create the database structure that are found in the DATAMODEL folder

Scripts for populating a test database can be found within the test/data folder.
 
There are three roles within the test database
toms_admin – with ability to accept/reject proposals, update restrictions in use …
toms_operator – ability to create proposal and make changes within a proposal
toms_public – read access


Users are then assigned to one of these roles. Typically user name are first_name.last_name, e.g., john.smith. There are three users that have been created for the test environment:
•	test_toms_admin with password “password”
•	test_toms_operator with password “password”
•	test_toms_public with password “password”

The test project file is found within the QGIS folder. This project file uses a postgres service to access the database. (See https://www.postgresql.org/docs/9.1/libpq-pgservice.html)

**QGIS-Server**

The test project file sets details for WMS and WFS services.

< Further details required here >

**Usage**

## Video

[![TOMs](https://img.youtube.com/vi/_sG7226QziE/0.jpg)](https://www.youtube.com/watch?v=_sG7226QziE)

< This video was the original concept. More details required here >

**Contributing**

Contributions are welcome - whether it be coding, documenting or moral support!. If you are willin/able to assist, please contact the developer(s) to discuss things further.

**Credits**

On-going support has been provide by ProjectCentre Ltd. Guidance and advice has come from OpenGIS.ch.

**License**

GNU GPLv3

Git revision : $Format:%H$
