#!/bin/bash

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo -e "Please provide an element as an argument."
  exit
fi

# Assign the provided argument to a variable for easier reference
ELEMENT=$1

# Define the PostgreSQL command with connection details
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Determine if the argument is numeric or not
if [[ $ELEMENT =~ ^[0-9]+$ ]]; then
  QUERY="SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type
  FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types on properties.type_id = types.type_id
  WHERE elements.atomic_number = $ELEMENT;"

elif [[ ${#ARGUMENT} -gt 2 ]]; then
  QUERY="SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type
  FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types on properties.type_id = types.type_id
  WHERE elements.name ILIKE '$ELEMENT';"

else
  QUERY="SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type
  FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types on properties.type_id = types.type_id
  WHERE elements.symbol = '$ELEMENT';"
fi

# Execute the query and save the result
RESULT=$($PSQL "$QUERY")

# Check if the query returned a result
if [[ -z "$RESULT" ]]; then
    echo "I could not find that element in the database."
else
    # Parse the result and display information about the element
    IFS='|' read -r atomic_number symbol name atomic_mass melting_point boiling_point type <<< "$RESULT"
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
fi
