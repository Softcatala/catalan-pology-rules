#!/bin/bash

get_number_of_messages_in_po_file() 
{
    msgfmt $1 --statistics 2> results.txt 
    sed 's/[^0-9]//g' results.txt > strings.txt
    strings=`cat strings.txt`
    echo $strings
}

# Look for the error message with the exact number of errors
# what pology returned
get_pology_error_msg_for_rules_errors()
{
    # Get number of strings in PO file
    msgfmt $1 --statistics 2> results.txt 
    sed 's/[^0-9]//g' results.txt > strings.txt
    strings=`cat strings.txt`
    error="===== Les regles han detectat " 
    error+=$(get_number_of_messages_in_po_file $1)
    error+=" problem"
    echo $error
}

failed=0
for filename in *.rules; do

    filename="${filename%.*}"
    correct="$filename-correct.po"
    incorrect="$filename-incorrect.po"

    # Check correct sentences for the rule
    posieve check-rules -s rfile:date-format.rules $correct > results.txt

    if grep -q "===== Les regles han detectat" results.txt; then
        echo "Pology found error(s) in file" $correct "where no errors were expected"
        failed=1
    fi

    # Check incorrect sentences
    error=$(get_pology_error_msg_for_rules_errors "$incorrect")

    # Check wrong sentences for the rule
    posieve check-rules -s rfile:date-format.rules $incorrect > results.txt

    if ! grep -q "$error" results.txt; then
        echo "Pology found different number of error(s) in file" $incorrect "than expected" 
        failed=1
    fi
done

if [ $failed -eq 1 ]; then
    exit 1
fi
    

