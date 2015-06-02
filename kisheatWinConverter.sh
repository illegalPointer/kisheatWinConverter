#!/bin/sh
# Fix to naming problem with kisheat.py when trying to work on Windows environments
# github.com/illegalPointer/kisheatWinConverter

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
    if [ -f $1$oldImageName ]
    then
     echo "$kmlNewImageName" >> "$kmlFile""TEMP"
     mv $1$oldImageName $1$newImageName
    else
     rm "$kmlFile"
     rm "$kmlFile""TEMP"
     break
    fi
    ;;
   *)
    echo "$line" >> "$kmlFile""TEMP"
    ;;
  esac
 done
 if [ -f "$kmlFile""TEMP" ]
 then
  echo "</kml>" >> "$kmlFile""TEMP"
  mv "$kmlFile""TEMP" "$kmlFile"
  newKmlFile=$(echo "$kmlFile" | sed 's/:/_/g')
  if [ "$kmlFile" != "$newKmlFile" ];
  then
   mv "$kmlFile" "$newKmlFile"
  fi
 fi
done

exit
