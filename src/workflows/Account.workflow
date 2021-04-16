<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Remove_Ending_Semicolon</fullName>
        <description>If Languages field ends in semicolon, delete that character</description>
        <field>Languages__c</field>
        <formula>LEFT(Languages__c, LEN(Languages__c) - 1)</formula>
        <name>Remove Ending Semicolon</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Languages Field</fullName>
        <actions>
            <name>Remove_Ending_Semicolon</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the languages field ends in semicolon, remove that character.</description>
        <formula>CONTAINS(RIGHT(Languages__c, 1), &quot;;&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
