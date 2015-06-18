#!/bin/bash

get_number_of_messages_in_po_file() 
{
    msgfmt $1 --statistics 2> results.txt 
    sed 's/[^0-9]//g' results.txt > strings.txt
    strings=`cat strings.txt`
    echo $strings
}

# Look for the error message with the exact number of errors
# what pology returned in Catalan
get_pology_error_msg_for_rules_errors()
{
    # Get number of strings in PO file
    msgfmt $1 --statistics 2> results.txt 
    sed 's/[^0-9]//g' results.txt > strings.txt
    strings=`cat strings.txt`
    error=$2
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
    if [ -s "$correct" ]; then
        posieve check-rules -s rfile:date-format.rules $correct > results.txt

        if grep -q "===== Les regles han detectat" results.txt; then
            echo "Pology found error(s) in file" $correct "where no errors were expected"
            cat results.txt
            failed=1
        fi
    fi

    # Check incorrect sentences
    if [ -s  "$incorrect" ]; then
        error_ca=$(get_pology_error_msg_for_rules_errors "$incorrect" "===== Les regles han detectat ")
        error_en=$(get_pology_error_msg_for_rules_errors "$incorrect" "===== Rules detected ")
        posieve check-rules -s rfile:date-format.rules $incorrect > results.txt

        if ! grep -q "$error_ca" results.txt && ! grep -q "$error_en" results.txt ; then
            echo "Pology found different number of error(s) in file" $incorrect "than expected"
            cat results.txt
            echo $error
            failed=1
        fi
    fi
done

rm results.txt

if [ $failed -eq 1 ]; then
    exit 1
fi
    

