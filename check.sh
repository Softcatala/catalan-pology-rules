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
get_pology_error_catalan_msg_for_rules_errors()
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


# Look for the error message with the exact number of errors
# what pology returned in English
get_pology_error_english_msg_for_rules_errors()
{
    # Get number of strings in PO file
    msgfmt $1 --statistics 2> results.txt 
    sed 's/[^0-9]//g' results.txt > strings.txt
    strings=`cat strings.txt`
    error="===== Rules detected " 
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
    error_ca=$(get_pology_error_catalan_msg_for_rules_errors "$incorrect")
    error_en=$(get_pology_error_english_msg_for_rules_errors "$incorrect")
    posieve check-rules -s rfile:date-format.rules $incorrect > results.txt

    if ! grep -q "$error_ca" results.txt && ! grep -q "$error_en" results.txt ; then
        echo "Pology found different number of error(s) in file" $incorrect "than expected"
        cat results.txt
        echo $error
        failed=1
    fi
done

if [ $failed -eq 1 ]; then
    exit 1
fi
    

