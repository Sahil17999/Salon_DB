#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

APPOINTMENT() {
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_OPTION'")
  NAME_CUST=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo -e "\nWhat time would you like your $(echo "$SERVICE_NAME" | sed 's/^ //'), $(echo "$NAME_CUST" | sed 's/^ //')?"
  read SERVICE_TIME
  CREATE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $(echo "$SERVICE_NAME" | sed 's/^ //') at $(echo "$SERVICE_TIME" | sed 's/^ //'), $(echo "$NAME_CUST" | sed 's/^ //')."
}

START () {
  if [[ $1 ]] 
  then 
    echo -e "\n$1\n"
  fi

  echo "$($PSQL "SELECT * FROM services")" | while read SERVICE_ID BAR NAME
  do 
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  SERVICE_OPTION=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_OPTION ]]
  then 
    START "I could not find that service. What would you like today?"
  else 
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    HAVE_CUSTOMER=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $HAVE_CUSTOMER ]] 
    then 
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERTED=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      #SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_OPTION'")
      #echo -e "\nWhat time would you like your $(echo "$SERVICE_NAME" | sed 's/^ //'), $(echo "$CUSTOMER_NAME" | sed 's/^ //')?"
      #CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME' AND phone = '$CUSTOMER_PHONE'")
      #read SERVICE_TIME
      APPOINTMENT

    else
    
      APPOINTMENT
    fi
  fi
}
START
