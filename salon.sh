#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

MAIN_MENU() {

  echo -e "\n~~~~~ MY SALON ~~~~~\n"
  echo -e "How can I help you?\n"

  SERVICE_LIST=$($PSQL "SELECT * FROM services")
  echo -e "\n$SERVICE_LIST" | sed 's/|/) /'
  read SERVICE_ID_SELECTED

  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [ -z "$SERVICE" ]
  then
    MAIN_MENU
  else
    echo -e "\nWhat is your phone?"
    read CUSTOMER_PHONE

    PHONE_VER=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

    if [ -z "$PHONE_VER" ]
    then
      echo -e "\nWhat is your name?"
      read CUSTOMER_NAME

      echo -e "\nHello $CUSTOMER_NAME. What time do you want for your $SERVICE?"
      read SERVICE_TIME

      $PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')" > /dev/null

      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

      $PSQL "INSERT INTO appointments(service_id,customer_id,time) VALUES($SERVICE_ID_SELECTED,$CUSTOMER_ID,'$SERVICE_TIME')" > /dev/null

      echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."

    else
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

      echo -e "\nWhat time do you want your $SERVICE, $CUSTOMER_NAME?"
      read SERVICE_TIME

      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

      $PSQL "INSERT INTO appointments(service_id,customer_id,time) VALUES($SERVICE_ID_SELECTED,$CUSTOMER_ID,'$SERVICE_TIME')" > /dev/null

      echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  fi
}

MAIN_MENU