// Stylesheet used in the CRMCaseCreationPage

.chosen-container-multi .chosen-drop .result-selected::before {
    content: url('/img/checkbox_checked.gif');
}

.tableWrapper {
    overflow: hidden;
    overflow-y: scroll;
}

select:disabled {
    display: none;
}

.pbBody a {
    color: #333;
}

.disabled {
    pointer-events: none;
    cursor: default;
}

label {
    color: #4a4a56;
    font-weight: bold;
}

.selectedRow {
    background-color: #e3f3ff;
}

tr.dataRow td:first-child {
    //text-align: center;
}

input[disabled] {
    cursor: not-allowed;
}

.hidden {
    display: none;
}

.lex_background {
    background-color: rgb(175, 197, 222);
    height: -webkit-fill-available;
    background-image: url(/_slds/images/themes/oneSalesforce/banner-brand-default.png?cache=210.2);
    background-repeat: repeat-x;
    background-position: top left;
}