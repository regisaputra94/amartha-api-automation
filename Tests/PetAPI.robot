*** Settings ***
Resource                ../Libraries/Routers.robot
Test Timeout            ${LONG_TEST_TIMEOUT}
# Test Setup              Base.Setup Test Environment

*** Test Cases ***
Create Transaction QRIS
    [Documentation]            API Automation
    [Tags]                     positive      development     production      functionalTest       QRIS

    Hit API order/booking       QRIS        ${SEAT}
    Validate Data Payment in DB mtix_payment        ${transaction_id}       QRIS
    Update Data Payment to Billed                   ${transaction_id}       QRIS
    Hit API order/inquiry                           ${transaction_id}       QRIS
    Validate Data Booked Code in DB mtix_transaction        ${transaction_id}
    Log to console              Transaciton ID -> ${transaction_id}, Booked Code -> ${BOOKED_CODE} ✅ Success Created

