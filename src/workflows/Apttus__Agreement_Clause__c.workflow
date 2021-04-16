<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CLM_Non_Standard_Legal_Language_Update</fullName>
        <field>Apttus__Non_Standard_Legal_Language__c</field>
        <literalValue>1</literalValue>
        <name>CLM Non Standard Legal Language Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Apttus__Agreement__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>CLM Modified from Standard</fullName>
        <actions>
            <name>CLM_Non_Standard_Legal_Language_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__Agreement_Clause__c.Apttus__Action__c</field>
            <operation>contains</operation>
            <value>Inserted,Modified,Deleted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
