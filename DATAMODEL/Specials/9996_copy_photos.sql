/*
To copy all required photos, steps are:
 1. Generate a file containining the list of files required
  - Possibly created from query in 9997_check_photos.sql
  - Ensure that file line endings of system (linux/windows)

 2. Copy for required folder/directory
  - for Linux use:

      prefix="/home/QGIS/projects/Islington/Mapping/photos"
      file="/home/tim/Downloads/photoList_210420.csv"
      while IFS= read -r line; do cp "$prefix/$line" /home/tim/ISL_Photos_210420; done < $file

  - for Windows ...

 3. For Islington, due to number of files, it was not possible to zip the whole folder/directory. Instead, files were grouped by month ...

*/