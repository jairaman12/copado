<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SkipValidation</fullName>
        <field>SkipValidation__c</field>
        <literalValue>0</literalValue>
        <name>SkipValidation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateProvId</fullName>
        <field>Prov_ID__c</field>
        <formula>Contracting_Case__r.Account.Prov_ID__c</formula>
        <name>UpdateProvId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Data Entry - Status Update</fullName>
        <actions>
            <name>SkipValidation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Provider_Networks__c.SkipValidation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update ProvId Based On Account</fullName>
        <actions>
            <name>UpdateProvId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Contracting_Case__c != NULL, isFirstProvider__c = True,  Contracting_Case__r.AccountId != NULL)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
