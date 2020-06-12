
TOMs (Traffic Order Management System)

Introduction
TOMs is a system for managing map based traffic orders. It is developed for use by local authorities in the UK - although the principles are applicable for any country.

TOMs provides users with the facility to:
 - view the current and proposed restrictions as at a given date
 - manage restrictions, i.e., create, edit and delete restrictions
 - print existing or proposed restriction details as at a given date

Concepts
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

System structure
TOMs is a python plugin that makes use of and extends tools within QGIS.  

It relies on a connection to a postgres/postgis database. Details of the data structure can be found in the wiki.


## Video

[![TOMs](https://img.youtube.com/vi/_sG7226QziE/0.jpg)](https://www.youtube.com/watch?v=_sG7226QziE)



Git revision : $Format:%H$
