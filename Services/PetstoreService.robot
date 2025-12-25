*** Settings ***
Resource                   ../Libraries/Routers.robot

*** Variables ***
${pet_endpoint}             /pet

*** Keywords ***
Hit API Create Pet
    [Documentation]    Hit API create pet (Swagger Petstore)
    [Arguments]        ${id}    ${pet_name}    ${status}

    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json

    ${category}=    Create Dictionary
    ...    id=0
    ...    name=string

    ${tag}=    Create Dictionary
    ...    id=0
    ...    name=string

    ${tags}=    Create List    ${tag}
    ${photo_urls}=    Create List    string

    ${payload}=    Create Dictionary
    ...    id=${id}
    ...    category=${category}
    ...    name=${pet_name}
    ...    photoUrls=${photo_urls}
    ...    tags=${tags}
    ...    status=${status}

    ${response}=    Post Request
    ...    service_name=petstore
    ...    service_url=${BASE_URL}
    ...    uri=${pet_endpoint}
    ...    extra_headers=${headers}
    ...    payload=${payload}

    ${data}=    Convert To Dictionary    ${response.json()}
    Validate Pet Response    ${response}    200
    Set To Dictionary    ${data}    status_code=${response.status_code}
    [Return]    ${data}

Validate Pet Response
    [Documentation]    Validasi status code dan JSON schema response create pet
    [Arguments]        ${response}    ${expected_status_code}

    # === Validate HTTP Status Code ===
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    ${expected_status_code}

    ${body}=    Convert To Dictionary    ${response.json()}

    # === Validate root fields ===
    Dictionary Should Contain Key    ${body}    id
    Dictionary Should Contain Key    ${body}    category
    Dictionary Should Contain Key    ${body}    name
    Dictionary Should Contain Key    ${body}    photoUrls
    Dictionary Should Contain Key    ${body}    tags
    Dictionary Should Contain Key    ${body}    status

    # === Validate category schema ===
    ${category}=    Get From Dictionary    ${body}    category
    Dictionary Should Contain Key    ${category}    id
    Dictionary Should Contain Key    ${category}    name

    # === Validate tags schema ===
    ${tags}=    Get From Dictionary    ${body}    tags
    Should Be True    ${tags} != None

    ${first_tag}=    Get From List    ${tags}    0
    Dictionary Should Contain Key    ${first_tag}    id
    Dictionary Should Contain Key    ${first_tag}    name

    # === Validate data type (optional but recommended) ===
    Should Be Equal    ${body['id'].__class__.__name__}        int
    Should Be Equal    ${body['name'].__class__.__name__}      str
    Should Be Equal    ${body['status'].__class__.__name__}    str


Validate Data Booked Code in DB mtix_transaction
    [Documentation]       Data transaction exists in database mtix_transaction
    [Arguments]           ${transaction_id}

    Query Select Data Transaction Table Transaction     ${transaction_id}

Update Data Payment to Billed
    [Documentation]       Update table payment to Billed
    [Arguments]           ${transaction_id}         ${payment}

    Update Data Transaction Database mtix_payment     ${transaction_id}     status      4       ${payment}

Hit API order/inquiry
    [Documentation]       Hit API order/booking
    [Arguments]           ${transaction_id}     ${payment}
    ${headers} =          Create Dictionary        
    ...    Content-Type=application/json
    ...    X-DEVICE-UIID=${DEVICE_ID}
    ...    X-DEVICE-TYPE=android
    ...    Authorization=${TOKEN}

    ${payload}=    Create Dictionary
    ...    cinema_id=${CINEMA}
    ...    edc_id=${payment}
    ...    transaction_id=${transaction_id}
    ...    type=ticket

    ${response}           Post Request              service_name=order-services     service_url=${SERVICE_DEV_MTIX}      uri=${path_orderInquiry}   extra_headers=${headers}   payload=${payload}
    ${data}               Convert To Dictionary     ${response.json()}
    Set To Dictionary     ${data}                   status_code=${response.status_code}          
    [Return]              ${data}

Create Bulk Transaction
    [Documentation]       Bulk Transaction
    [Arguments]           ${payment}        ${total_ticket}
    Log to console          Start...
    FOR     ${i}    IN RANGE     ${total_ticket}
        Base.Setup Test Environment
        Hit API order/booking       ${payment}        ${SEAT}
        Validate Data Payment in DB mtix_payment        ${transaction_id}       ${payment}
        Update Data Payment to Billed                   ${transaction_id}       ${payment}
        Hit API order/inquiry                           ${transaction_id}       ${payment}
        Validate Data Booked Code in DB mtix_transaction        ${transaction_id}
        Log to console              Transaciton ID -> ${transaction_id}, Booked Code -> ${BOOKED_CODE} ✅ Success Created
    END
    