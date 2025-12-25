*** Settings ***
Resource                   ../Libraries/Routers.robot

*** Variables ***
${path_orderBooking}        /order/booking
${path_orderInquiry}        /order/inquiry

*** Keywords ***
Hit API order/booking
    [Documentation]       Hit API order/booking
    [Arguments]           ${payment}        ${SEAT}
    ${studio_id}=    Convert To String    ${SCHEDULE['studio_id'][${INDEX_SHOW}]}
    ${headers} =          Create Dictionary        
    ...    Content-Type=application/json
    ...    X-DEVICE-UIID=${DEVICE_ID}
    ...    X-DEVICE-TYPE=android
    ...    Authorization=${TOKEN}

    ${payload}=    Create Dictionary
    ...    cinema_id=${CINEMA}
    ...    studio_id=${studio_id}
    ...    movie_id=${SCHEDULE['movie_id']}
    ...    date_show=${DATE_SHOW}
    ...    time_show=${SCHEDULE['time_show'][${INDEX_SHOW}]}
    ...    vcr_data=
    ...    fpd_data=
    ...    seat=${SEAT}
    ...    edc_id=${payment}

    #dinamic schedule

    ${response}           Post Request              service_name=order-services     service_url=${SERVICE_DEV_MTIX}      uri=${path_orderBooking}   extra_headers=${headers}   payload=${payload}
    ${data}               Convert To Dictionary     ${response.json()}
    Set To Dictionary     ${data}                   status_code=${response.status_code}
    Set Test Variable     ${transaction_id}         ${data['data']['value']['transaction_id']}
    [Return]              ${data}

Validate Data Payment in DB mtix_payment
    [Documentation]       Data transaction exists in database mtix_payment
    [Arguments]           ${transaction_id}         ${payment}

    Query Select Data Transaction Table Payment     ${transaction_id}       ${payment}

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
    