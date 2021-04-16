<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Remove_PFIN_Designation_Ending_Semicolon</fullName>
        <description>If the PFIN Designations field ends in semicolon, remove that character.</description>
        <field>PFIN_Designations__c</field>
        <formula>LEFT(PFIN_Designations__c, LEN(PFIN_Designations__c) - 1)</formula>
        <name>Remove PFIN Designation Ending Semicolon</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update PFIN Desiginations</fullName>
        <actions>
            <name>Remove_PFIN_Designation_Ending_Semicolon</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the PFIN Designations field ends in semicolon, remove that character.</description>
        <formula>CONTAINS(RIGHT(PFIN_Designations__c, 1), &quot;;&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
