#!/bin/bash

export PGPASSWORD=freecodecamp
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo -e "\nWelcome to My Salon, how can I help you?\n"
  fi

  $PSQL "SELECT service_id, name FROM services ORDER BY service_id" | while IFS="|" read ID NAME
  do
    echo "$ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]] || [[ -z $($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED") ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    BOOK_APPOINTMENT
  fi
}

BOOK_APPOINTMENT() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    SAFE_NAME=${CUSTOMER_NAME//\'/\'\'}
    $PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$SAFE_NAME')" > /dev/null
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  fi

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")

  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  SAFE_TIME=${SERVICE_TIME//\'/\'\'}

  $PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SAFE_TIME')" > /dev/null

  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU