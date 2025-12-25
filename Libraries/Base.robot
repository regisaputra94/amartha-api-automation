*** Settings ***
Resource                ./Routers.robot

*** Keywords ***
Post Request
    [Arguments]    ${service_name}    ${service_url}    ${uri}
    ...            ${extra_headers}=    ${params}=    ${payload}=
    ...            ${expected_status}=200

    Create Session    ${service_name}    ${service_url}    verify=true

    # ${default_headers}=    Create Dictionary    Content-Type=application/json

    # Merge jika user memberikan header
    # Run Keyword If    '${extra_headers}' != ''
    # ...    Set To Dictionary    ${default_headers}    &{extra_headers}

    ${resp}=    POST On Session
    ...    alias=${service_name}
    ...    url=${uri}
    ...    headers=${extra_headers}
    ...    params=${params}
    ...    json=${payload}
    ...    expected_status=${expected_status}

    Log    ${resp.json()}    formatter=repr
    [Return]    ${resp}

Get Request
    [Arguments]    ${service_name}    ${service_url}    ${uri}
    ...            ${extra_headers}=    ${params}=    ${expected_status}=200

    Create Session    ${service_name}    ${service_url}    verify=true

    ${resp}=    GET On Session
    ...    alias=${service_name}
    ...    url=${uri}
    ...    headers=${extra_headers}
    ...    params=${params}
    ...    expected_status=${expected_status}

    Log    ${resp.json()}    formatter=repr
    [Return]    ${resp}
