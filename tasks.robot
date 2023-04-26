*** Settings ***
Documentation       And example implementation of reading XML
...                 files and dispathing them as payloads to
...                 other processes.

Library             XML    use_lxml=True
Library             OperatingSystem
Library             RPA.Robocorp.Process
Library             RPA.Robocorp.Vault


*** Variables ***
${XML_FILES_PATH}       xmls
${PROCESS1_TEXT}        OTHER_THING
${PROCESS2_TEXT}        SOME_THING


*** Tasks ***
Dispatch XMLs
    # Get list of all .xml files in a folder
    ${xml_files}=    List Files In Directory    ${XML_FILES_PATH}    pattern=*.xml

    # Loop through each file
    FOR    ${xml_file}    IN    @{xml_files}
        ${value}=    Process a file    ${XML_FILES_PATH}${/}${xml_file}

        # This is where you'd implement the checks for each process
        IF    $value == $PROCESS1_TEXT
            Trigger a process    process_id_1    ${xml_file}
        ELSE IF    $value == $PROCESS2_TEXT
            Trigger a process    process_id_2    ${xml_file}
        ELSE
            Log    No matching process found for ${value}
        END
    END


*** Keywords ***
Process a file
    [Arguments]    ${xml_file_path}
    Log To Console    ${xml_file_path}

    # Next three lines get the element that determines the further processing behaviour.
    # They would need to be adjusted to match the XMLs you have.
    ${root}=    Parse Xml    ${xml_file_path}
    ${first_element}=    Get Element    ${root}    first
    ${value}=    Get Element Attribute    ${first_element}    id
    RETURN    ${value}

Trigger a process
    [Arguments]    ${which_process}    ${xml_file}

    # The workspace, process and api keys need to be set up in Vault
    ${secrets}=    Get Secret    dispatch_demo
    Set Credentials
    ...    ${secrets}[workspace_id]
    ...    ${secrets}[${which_process}]
    ...    ${secrets}[apikey]

    # This will add the entire XML file in the work item for the process.
    # It's better practise than putting it in as payload, since payload has
    # much smaller max size.
    ${item_id}=    Create Input Work Item    files=${XML_FILES_PATH}${/}${xml_file}
    Start Configured Process    config_type=work_items    extra_info=${item_id}
