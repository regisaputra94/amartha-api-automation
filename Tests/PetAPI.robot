*** Settings ***
Resource                ../Libraries/Routers.robot
Test Timeout            ${LONG_TEST_TIMEOUT}
# Test Setup              Base.Setup Test Environment
# Test Teardown           Base.Delete date created

*** Test Cases ***
Scenario 1 - Create Pet In Store
    [Documentation]            API Automation - Automate add new pet test case. Create 1 pet with name is "Cat1" and verify that pet has been created.
    [Tags]                     positive      functionalTest     create
    [Teardown]                 Hit API Delete Pet By ID     ${random_id}
    ${random_id}=    Generate 4 Digit Id
    Hit API Create Pet    ${random_id}    Cat1    available
    Verify Pet Created    ${random_id}    Cat1

Scenario 2 - Create Pet In Store
    [Documentation]            API Automation - Automate add new pet test case. Create 1 pet with name is "Cat2" and verify that pet has been created.
    [Tags]                     positive      functionalTest     create
    [Teardown]                 Hit API Delete Pet By ID     ${random_id}
    ${random_id}=    Generate 4 Digit Id
    Hit API Create Pet    ${random_id}    Cat2    available
    Verify Pet Created    ${random_id}    Cat2

Scenario 3 - Find Pet by Status
    [Documentation]            API Automation - Automate find pet by status test case. Get pets with status is "available" and verify that response only show pets with correct status.
    [Tags]                     positive      functionalTest     get     byStatus
    ${data}=        Hit API Find Pet By Status      available
    Validate Find Pet By Status Response    ${data}     available

Scenario 4 - Find Pet by Status
    [Documentation]            API Automation - Automate find pet by status test case. Get pets with status is "pending" and verify that response only show pets with correct status.
    [Tags]                     positive      functionalTest     get     byStatus
    ${data}=        Hit API Find Pet By Status      pending
    Validate Find Pet By Status Response    ${data}     pending

Scenario 5 - Find Pet by ID
    [Documentation]            API Automation - Automate find pet by id test case. Get pet with id is 2 (or other that give http 200 response) and verify that the response is in comply with the contract.
    [Tags]                     positive      functionalTest     get     byId
    Hit API Get Pet By ID      528061
    