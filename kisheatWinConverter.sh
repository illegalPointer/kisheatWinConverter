#!/bin/sh
# Fix to naming problem with kisheat.py when working on Windows environments
# github.com/illegalPointere/kisheatWinConverter

numArgs=1

if [ $# -ne $numArgs ]
then
 echo "Usage: sh kisheatWinConverter <Route to kml png dir>"
 exit
fi

echo "Gonna work with ksh and png from dir: $1"

ls $1*.kml | while read -r kmlFile;
do
 #To preserve XML tab indentation, we use line instead of read
 cat "$kmlFile" | while line=$(line);
 do
  case "$line" in 
   *href*)
    oldImageName=$(echo "$line" | sed 's/<\/\?href>//g;s/ //g')
    kmlNewImageName=$(echo "$line" | sed 's/:/_/g')
    newImageName=$(echo "$oldImageName" | sed 's/:/_/g')
    echo "$kmlNewImageName" >> "$kmlFile""TEMP"
    mv $1$oldImageName $1$newImageName
    ;;
   *)
    echo "$line" >> "$kmlFile""TEMP"
    ;;
  esac
 done
 echo "</kml>" >> "$kmlFile""TEMP"
 mv "$kmlFile""TEMP" "$kmlFile"
 newKmlFile=$(echo "$kmlFile" | sed 's/:/_/g')
 mv "$kmlFile" "$newKmlFile"
done

exit