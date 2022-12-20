*** Settings ***
Documentation       Orders robots from RobotSpareBin Industries Inc.
...                 Saves the order HTML receipt as a PDF file.
...                 Saves the screenshot of the ordered robot.
...                 Embeds the screenshot of the robot to the PDF receipt.
...                 Creates ZIP archive of the receipts and the images.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.HTTP
Library             RPA.PDF
Library             RPA.Tables
Library             RPA.Archive
Library             RPA.RobotLogListener
Library             RPA.Robocorp.Vault

*** Variables ***
${web}    https://robotsparebinindustries.com/#/robot-order
${csv_web}    https://robotsparebinindustries.com/orders.csv  
${receipt_dir}    ${OUTPUT_DIR}${/}receipts/
${sshot_dir}    ${OUTPUT_DIR}${/}screenshot/
${zip_dir}    ${OUTPUT_DIR}${/}

*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the robot order website
    ${orders}=    Get orders
    FOR    ${row}    IN    @{orders}
       Close the annoying modal
       Fill the form    ${row}
       Wait Until Keyword Succeeds     10x     2s    Preview the robot
       Wait Until Keyword Succeeds     10x     2s    Submit the order
    #    ${pdf}=    Store the receipt as a PDF file    ${row}[Order number]
    #    ${screenshot}=    Take a screenshot of the robot    ${row}[Order number]
    #    Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}
       Go to order another robot
    END
    # Create a ZIP file of the receipts
    Log out and close the browser


*** Keywords ***
Open the robot order website
    Open Available Browser    ${web}

Get orders
    Download    ${csv_web}    overwrite=True
    ${tab}=     Read table from CSV    orders.csv
    [Return]    ${tab}

Close the annoying modal
    Click Button    OK
    Wait Until Page Contains Element    class:form-group

Fill the form
    [Arguments]    ${roww}
    Select From List By Value    head    ${roww}[Head]
    Select Radio Button    body    ${roww}[Body]
    Input Text    xpath://html/body/div/div/div[1]/div/div[1]/form/div[3]/input    ${roww}[Legs]
    Input Text    address    ${roww}[Address]

    # Select From List By Value    head    1
    # Select Radio Button    body    1
    # Input Text    xpath://html/body/div/div/div[1]/div/div[1]/form/div[3]/input    1

Preview the robot
    Click Button    preview
    Wait Until Element Is Visible    robot-preview-image
Submit the order
    Mute Run On Failure    Page Should Contain Element     
    Click Button    order
    Page Should Contain Element    receipt
Store the receipt as a PDF file
    [Arguments]    ${ord_num}
    

    # Wait Until Element Is Visible    id:sales-results
    # ${sales_results_html}=    Get Element Attribute    id:sales-results    outerHTML
    # Html To Pdf    ${sales_results_html}    ${OUTPUT_DIR}${/}sales_results.pdf

Take a screenshot of the robot


Embed the robot screenshot to the receipt PDF file


Go to order another robot
    Wait Until Keyword Succeeds    10x    1s    Click Button When Visible    order-another
Create a ZIP file of the receipts


Log out and close the browser
    Close Browser