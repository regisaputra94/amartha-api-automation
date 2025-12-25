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

Hit API Get Pet By ID
    [Documentation]    Hit API get pet by id (Swagger Petstore)
    [Arguments]        ${id}    ${expected_name}

    ${headers}=    Create Dictionary
    ...    Accept=application/json

    ${response}=    Get Request
    ...    service_name=petstore
    ...    service_url=${BASE_URL}
    ...    uri=${pet_endpoint}/${id}
    ...    extra_headers=${headers}

    ${data}=    Convert To Dictionary    ${response.json()}
    Validate Get Pet Response    ${response}    ${expected_name}
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


Verify Pet Created
    [Documentation]    Validasi status code dan JSON schema response create pet
    [Arguments]        ${id}    ${expected_name}
    Hit API Get Pet By ID      ${id}    ${expected_name}
    

Validate Get Pet Response
    [Documentation]    Validasi status code dan JSON schema response get pet by id
    [Arguments]    ${response}    ${expected_name}
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=    Convert To Dictionary    ${response.json()}
    Should Be Equal    ${body['name']}    ${expected_name}