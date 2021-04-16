<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Remove_Ending_Semicolon_From_Network</fullName>
        <description>PPN-23639: Remove ending semicolon from Provider Network Designation Field upon dataload.</description>
        <field>CM_Provider_Network_Designation__c</field>
        <formula>LEFT(CM_Provider_Network_Designation__c, LEN(CM_Provider_Network_Designation__c) - 1)</formula>
        <name>Remove Ending Semicolon From Network</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Provider Network Designation</fullName>
        <actions>
            <name>Remove_Ending_Semicolon_From_Network</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>PPN-23639: Remove ending semicolon from Provider Network Designation Field upon dataload.</description>
        <formula>CONTAINS(RIGHT(CM_Provider_Network_Designation__c, 1), &quot;;&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
