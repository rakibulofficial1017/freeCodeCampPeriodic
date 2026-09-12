#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi
ELEMENT=$1
ELEMENT_INFO=$($PSQL "
SELECT
  elements.atomic_number,
  elements.name,
  elements.symbol,
  types.type,
  properties.atomic_mass,
  properties.melting_point_celsius,
  properties.boiling_point_celsius
FROM elements
JOIN properties
  ON elements.atomic_number = properties.atomic_number
JOIN types
  ON properties.type_id = types.type_id
WHERE elements.atomic_number::TEXT = '$ELEMENT'
   OR elements.symbol = '$ELEMENT'
   OR elements.name = '$ELEMENT'
")

if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT_INFO"
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."

