*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${base_url}     http://localhost:3001

*** Test Cases ***
Get_weatherInfo
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