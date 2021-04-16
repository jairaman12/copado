<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Credentialing Report</label>
    <protected>false</protected>
    <values>
        <field>CaseStatusValues__c</field>
        <value xsi:type="xsd:string">New;In Progress</value>
    </values>
    <values>
        <field>EmailSubject__c</field>
        <value xsi:type="xsd:string">SF- Credentialing Report</value>
    </values>
    <values>
        <field>Failures_Report_Recipents__c</field>
        <value xsi:type="xsd:string">ProviderIntakeDev@bcbstx.com;ProviderIntakeBA@bcbstx.com</value>
    </values>
    <values>
        <field>FileName__c</field>
        <value xsi:type="xsd:string">SF_Credentialing Report_</value>
    </values>
    <values>
        <field>HeaderListing__c</field>
        <value xsi:type="xsd:string">Case Number,Prov ID,Provider Name,Network Name,Date/Time Opened,Status</value>
    </values>
    <values>
        <field>MainQuery2__c</field>
        <value xsi:type="xsd:string">SELECT Id, Network_Name__c,Contract_ProvID__c,account.Name, 
accountid, CaseNumber, 
CreatedDate, status FROM Case WHERE parentid != null and recordtype.developername in :recordTypeNames2 and 
status in :caseStatusValues 
and Contract_ProvID__c != null and Cred_Case_Reported__c = false</value>
    </values>
    <values>
        <field>MainQuery__c</field>
        <value xsi:type="xsd:string">SELECT Id, createddate,Network_Code_Name_Detail__c, 
Credentialing_Case__r.Id, Credentialing_Case__r.account.Name, 
Credentialing_Case__r.accountid, 
Credentialing_Case__r.CaseNumber, prov_id__c, 
Credentialing_Case__r.CreatedDate, Credentialing_Case__r.status FROM provider_networks__C 
WHERE Credentialing_Case__r.parentid != null and Credentialing_Case__r.recordtype.developername in :recordTypeNames and 
Credentialing_Case__r.status in :caseStatusValues 
and prov_id__c != null and Credentialing_Case__r.Cred_Case_Reported__c = false</value>
    </values>
    <values>
        <field>RecipientEmailList__c</field>
        <value xsi:type="xsd:string">ProviderIntakeBA@bcbstx.com;TXPAReporting@bcbstx.com;ProviderIntakeDev@bcbstx.com</value>
    </values>
    <values>
        <field>Record_Types__c</field>
        <value xsi:type="xsd:string">Provider_On_boarding_Credentialing;Provider_Manual_Group_On_boarding_Credentialling</value>
    </values>
    <values>
        <field>Record_types2__c</field>
        <value xsi:type="xsd:string">Provider_Group_On_boarding_Credentialling</value>
    </values>
    <values>
        <field>body__c</field>
        <value xsi:type="xsd:string">See attached file</value>
    </values>
</CustomMetadata>
