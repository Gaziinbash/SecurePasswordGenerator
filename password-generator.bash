#!/usr/bin/env bash

# - To change the input prompt of the Select Loop
PS3="Select: "

# - Check if the file "passwords" exists in the directory.
if [[ ! -e "passwords.txt" ]]; then
    touch passwords.txt
fi

# =========================
# - Ask the user for the password length
read -p "- Password Length: " passwordLength

# - Check if the password length is not a number
if [[ ! "$passwordLength" =~ ^[0-9]+$ ]]; then
    echo "- Error: \"$passwordLength\" is not a number."
    exit 1
fi

# - Check the password length
if [[ "$passwordLength" -lt "5" ]] || [[ "$passwordLength" -ge "128" ]]; then
    echo "- Error: Your password must be longer than 5 characters and shorter than 128 characters."
    exit 1
fi

characters=\
"ABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz
0123456789
@#!$%&"

password=$(head /dev/urandom | tr -dc "$characters" | head -c$passwordLength)

echo "- Your generated password is: $password"

select option in "Save your password in a file" "Cancel and Exit"; do
    case "$REPLY" in
        1)
            while :; do
                read -p "- Do you want to specify where you will use the password? [Y/n]" optionSave

                if [[ "$optionSave" = "Y" ]] || [[ "$optionSave" = "y" ]] || [[ -z "$optionSave" ]]; then
                    read -p "Type where you will use the password: " usageLocation
                    savedPassword="$password - $usageLocation"

                    echo -e "\n$savedPassword" >> password
                    exit 0
                elif [[ "$optionSave" = "N" ]] || [[ "$optionSave" = "n" ]]; then
                    echo -e "\n$password" >> password
                    exit 0
                else echo "Invalid option \"$optionSave\"."

                fi
            done
        ;;

        2) exit 0 ;;

        *) echo "Invalid option \"$REPLY\"." ;;
    esac
done