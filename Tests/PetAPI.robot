*** Settings ***
Resource                ../Libraries/Routers.robot
Test Timeout            ${LONG_TEST_TIMEOUT}
# Test Setup              Base.Setup Test Environment

*** Test Cases ***
Create Pet In Store
    [Documentation]            API Automation
    [Tags]                     positive      development     production      functionalTest       QRIS
    ${random_id}=    Generate 4 Digit Id
    ${result}=    Hit API Create Pet    ${random_id}    Cat1    available
    # validate data berhasil inserted by endpoint /pet/{id}