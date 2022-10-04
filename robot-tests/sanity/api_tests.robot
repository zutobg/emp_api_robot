*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    String

*** Variables ***
${base_url}     http://localhost:3001
${tx_id}

*** Test Cases ***
Smoke_api_response
    create session  mysession   ${base_url}
    ${response}=    GET On Session    mysession    /payment_transactions

#    log to console    ${response.url}
#    log to console    ${response.status_code}
#    log to console    ${response.content}
#    log to console    ${response.headers}

    ${response_url}=    convert to string    ${response.url}
    ${response_status}=     convert to string    ${response.status_code}
    ${body}=    convert to string    ${response.content}
    ${content_type_value}=      get from dictionary    ${response.headers}      Content-Type

    #Validations
    should be equal    ${response_url}      http://localhost:3001/payment_transactions
    should be equal    ${response_status}       200     #change to 201 for failure check - it fails as expetced
    should contain    ${body}   UTC     #change to GMT for failure check - it fails as expected
    should be equal    ${content_type_value}    application/json; charset=utf-8

Post_test_success
    ${auth}=    create list    codemonster    my5ecret-key2o2o
    ${header}=      create dictionary    Content-Type=application/json;charset=utf-8
    &{request}=    create dictionary    card_number=4200000000000000
    ...    cvv=123
    ...    expiration_date=13/20192
    ...    amount=55
    ...    usage=robot_finally_worked
    ...    transaction_type=sale
    ...    card_holder=dssdds
    ...    email=pandaa@exadfdmple.com
    ...    address=dfdf

    &{body}=    create dictionary    payment_transaction=&{request}
    ${body_string}=    convert to string    ${body}
    ${body_json}=   replace string    ${body_string}   '   "

    create session  mysession   ${base_url}    auth=${auth}

    ${response}=    POST On Session    mysession    /payment_transactions   data=${body_json}    headers=${header}

    #log to console    ${response.status_code}
    #log to console    ${response.content}

#Keyword 'RequestsLibrary.To Json' is deprecated. Please use ${resp.json()} instead. Have a look at the improved HTML output as pretty printing replacement.
    ${json_response}    to json   ${response.content}
    ${response.status}=    get value from json    ${json_response}    $.status

    ${tx_id}=    get value from json    ${json_response}    $.unique_id
    set global variable    ${tx_id}

    #Validations
    should be equal    ${response.status[0]}    approved

Post_test_void
    ${auth}=    create list    codemonster    my5ecret-key2o2o
    ${header}=      create dictionary    Content-Type=application/json;charset=utf-8
    &{request}=    create dictionary    reference_id=${tx_id[0]}
    ...    transaction_type=void

    &{body}=    create dictionary    payment_transaction=&{request}
    ${body_string}=    convert to string    ${body}
    ${body_json}=   replace string    ${body_string}   '   "

    create session  mysession   ${base_url}    auth=${auth}

    ${response}=    POST On Session    mysession    /payment_transactions   data=${body_json}    headers=${header}

    ${json_response}    to json   ${response.content}
    ${response.status}=    get value from json    ${json_response}    $.status
    ${response.message}=    get value from json    ${json_response}    $.message

    #Validations
    should be equal    ${response.status[0]}    approved
    should be equal    ${response.message[0]}    Your transaction has been voided successfully

Post_test_empty
    ${auth}=    create list    codemonster    my5ecret-key2o2o
    ${header}=      create dictionary    Content-Type=application/json;charset=utf-8
    &{request}=    create dictionary    card_number=${EMPTY}
    ...    cvv=${EMPTY}
    ...    expiration_date=${EMPTY}
    ...    amount=${EMPTY}
    ...    usage=${EMPTY}
    ...    transaction_type=sale
    ...    card_holder=${EMPTY}
    ...    email=${EMPTY}
    ...    address=${EMPTY}

    &{body}=    create dictionary    payment_transaction=&{request}
    ${body_string}=    convert to string    ${body}
    ${body_json}=   replace string    ${body_string}   '   "

    create session  mysession   ${base_url}    auth=${auth}

    ${response}=    run keyword and ignore error    POST On Session    mysession    /payment_transactions   data=${body_json}    headers=${header}

    ${response_string}     convert to string    ${response}
    should contain    ${response_string}   422

    #Validations
#    should be equal    ${response.status[0]}    approved
#Started POST "/payment_transactions" for 127.0.0.1 at 2022-10-03 23:02:09 +0300
 #Processing by V1::PaymentTransactionsController#create as */*
 #  Parameters: {"payment_transaction"=>{"card_number"=>"", "cvv"=>"", "expiration_date"=>"", "amount"=>"", "usage"=>"", "transaction_type"=>"sale", "card_holder"=>"", "email"=>"", "address"=>""}}
 #  [1m[35m (0.1ms)[0m  [1m[36mbegin transaction[0m
 #  [1m[35m (0.1ms)[0m  [1m[31mrollback transaction[0m
 #Completed 422 Unprocessable Entity in 879ms (Views: 0.3ms | ActiveRecord: 0.2m

Post_test_space
#it turns out im only able to validate the error message and the status of the post response with the library im using
# so i'll not be able to make diff test for every field and by automation i'll be able to just verify positive and
#negative results and only find the reason info for the back end validation by log debugging it - which is fine
    ${auth}=    create list    codemonster    my5ecret-key2o2o
    ${header}=      create dictionary    Content-Type=application/json;charset=utf-8
    &{request}=    create dictionary    card_number=${SPACE}
    ...    cvv=${SPACE}
    ...    expiration_date=${SPACE}
    ...    amount=${SPACE}
    ...    usage=${SPACE}
    ...    transaction_type=sale
    ...    card_holder=${SPACE}
    ...    email=${SPACE}
    ...    address=${SPACE}

    &{body}=    create dictionary    payment_transaction=&{request}
    ${body_string}=    convert to string    ${body}
    ${body_json}=   replace string    ${body_string}   '   "

    create session  mysession   ${base_url}    auth=${auth}

    ${response}=    run keyword and ignore error    POST On Session    mysession    /payment_transactions   data=${body_json}    headers=${header}

    ${response_string}     convert to string    ${response}
    should contain    ${response_string}   422

Post_test_validation
    ${auth}=    create list    codemonster    my5ecret-key2o2o
    ${header}=      create dictionary    Content-Type=application/json;charset=utf-8
    &{request}=    create dictionary    card_number=4200000000000000
    ...    cvv=123
    ...    expiration_date=13/2022
    ...    amount=0
    ...    usage=afdfdfd
    ...    transaction_type=sale
    ...    card_holder=sdfgfdg
    ...    email=sdsdsd@rsdsd.bg
    ...    address=sd

    &{body}=    create dictionary    payment_transaction=&{request}
    ${body_string}=    convert to string    ${body}
    ${body_json}=   replace string    ${body_string}   '   "

    create session  mysession   ${base_url}    auth=${auth}

    ${response}=    run keyword and ignore error    POST On Session    mysession    /payment_transactions   data=${body_json}    headers=${header}

    #log to console    ${response.status_code}
    #log to console    ${response}
    ${response_string}     convert to string    ${response}
    should contain    ${response_string}   422


#    ${json_response}    to json   ${response.content}
#    ${response.status}=    get value from json    ${json_response}    $.status