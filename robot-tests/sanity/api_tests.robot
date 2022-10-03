*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    String

*** Variables ***
${base_url}     http://localhost:3001

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

Post_tests
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

    #Validations
    should be equal    ${response.status[0]}    approved