<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CLM_Agreement_Expiration_Alert</fullName>
        <description>CLM Agreement Expiration Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CLM_HCSC_Agreement_Expiration_Notification</template>
    </alerts>
    <alerts>
        <fullName>CLM_Auto_Renewal_Email_Notification</fullName>
        <description>CLM - Auto Renewal Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CLM_HCSC_Agreement_Auto_Renewal_Notification</template>
    </alerts>
    <alerts>
        <fullName>CLM_Auto_Renewal_Notice</fullName>
        <description>CLM - Auto Renewal Notice</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CLM_HCSC_Agreement_Auto_Renewal_Notice</template>
    </alerts>
    <alerts>
        <fullName>CLM_HCSC_Agreement_90_Day_Expiration_Alert</fullName>
        <description>CLM - HCSC Agreement 90 Day Expiration Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CLM_HCSC_Agreement_Prior_to_Expiration_Notification</template>
    </alerts>
    <alerts>
        <fullName>CLM_HCSC_Agreement_Activation_Alert</fullName>
        <description>CLM - HCSC Agreement Activation Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CLM_HCSC_Agreement_Activation_Notification</template>
    </alerts>
    <alerts>
        <fullName>CLM_HCSC_Agreement_Approval_Approved</fullName>
        <description>CLM - HCSC Agreement Approval Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CLM_HCSC_Agreement_Approval_Approved</template>
    </alerts>
    <alerts>
        <fullName>CLM_HCSC_Agreement_Approval_Rejected</fullName>
        <description>CLM - HCSC Agreement Approval Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CLM_HCSC_Agreement_Approval_Rejected</template>
    </alerts>
    <alerts>
        <fullName>CLM_HCSC_Agreement_Termination_Alert</fullName>
        <description>CLM - HCSC Agreement Termination Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/CLM_HCSC_Agreement_Termination_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Apttus__SearchFieldUpdate</fullName>
        <description>Update the account search field with Account Name</description>
        <field>Apttus__Account_Search_Field__c</field>
        <formula>Apttus__Account__r.Name  &amp;  Apttus__FF_Agreement_Number__c</formula>
        <name>Search Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus__SetAgreementNumber</fullName>
        <description>Set agreement number from the auto generated contract number</description>
        <field>Apttus__Agreement_Number__c</field>
        <formula>Apttus__Contract_Number__c</formula>
        <name>Set Agreement Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus__SetClonetriggertofalse</fullName>
        <description>Set Clone trigger to false</description>
        <field>Apttus__Workflow_Trigger_Created_From_Clone__c</field>
        <literalValue>0</literalValue>
        <name>Set Clone trigger to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_ADD_the_months</fullName>
        <field>Initial_Term__c</field>
        <formula>ADDMONTHS( Initial_Term__c , VALUE( TEXT( Initial_Term_Months__c ) ) )</formula>
        <name>CLM-ADD the months</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Account_to_Provider_Name</fullName>
        <field>Provider_Name__c</field>
        <formula>IF( Apttus__Account__r.Name == null,  Apttus__Account__r.FirstName + &quot; &quot; +  Apttus__Account__r.MiddleName + &quot; &quot; + Apttus__Account__r.LastName,  Apttus__Account__r.Name  )</formula>
        <name>CLM Account to Provider Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Add_Initial_Term_Months</fullName>
        <description>Now add the Initial Term Months</description>
        <field>Initial_Term_Date__c</field>
        <formula>ADDMONTHS(  Initial_Term_Date__c  , VALUE( TEXT( Initial_Term_Months__c ) ) )</formula>
        <name>CLM-Add Initial Term Months</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Add_the_Initial_Term_Years</fullName>
        <description>Initially add the Initial Term years to the Start date</description>
        <field>Initial_Term_Date__c</field>
        <formula>ADDMONTHS(Apttus__Contract_Start_Date__c , (VALUE( TEXT( Initial_Term_years__c ))*12) )</formula>
        <name>CLM-Add the Initial Term Years</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Add_the_months1</fullName>
        <field>Initial_Term__c</field>
        <formula>ADDMONTHS( Initial_Term__c , VALUE( TEXT( Initial_Term_Months__c ) ) )</formula>
        <name>CLM-Add the months1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Approval_Cancelled</fullName>
        <description>Once an approval flow is cancelled the Approval Status updates to Not Submitted</description>
        <field>Apttus_Approval__Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>CLM Approval Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Arbitration_Default_Illinois</fullName>
        <field>Arbitration_City__c</field>
        <literalValue>Chicago, IL</literalValue>
        <name>CLM - Arbitration Default Illinois</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Arbitration_Default_Montana</fullName>
        <field>Arbitration_City__c</field>
        <literalValue>Helena, MT</literalValue>
        <name>CLM - Arbitration Default Montana</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Arbitration_Default_New_Mexico</fullName>
        <field>Arbitration_City__c</field>
        <literalValue>Albuquerque, NM</literalValue>
        <name>CLM - Arbitration Default New Mexico</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Calculate_Initial_Term_Date_Default</fullName>
        <description>Inititial Term Date = Start Date + INitial Term Years + initial Term Months</description>
        <field>Initial_Term__c</field>
        <formula>ADDMONTHS(Apttus__Contract_Start_Date__c , (VALUE( TEXT( Initial_Term_years__c ))*12) )</formula>
        <name>CLM-Calculate Initial Term Date Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Defaul_for_Attachment_Effective_Date</fullName>
        <description>Set up Default value for Attachment Efective Date to Agreement Start Date</description>
        <field>Attachment_Effective_Date__c</field>
        <formula>Apttus__Contract_Start_Date__c</formula>
        <name>CLM Attachment Effective Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Default_for_Initial_Term_Date</fullName>
        <description>Set Default for Initial Term Date = Start Date + Initial Term Years + Initial Term Months</description>
        <field>Initial_Term__c</field>
        <formula>ADDMONTHS(Apttus__Contract_Start_Date__c ,  VALUE( TEXT( Initial_Term_years__c ) ) * 12 +  VALUE (TEXT(Initial_Term_Months__c)) )</formula>
        <name>CLM-Default for Initial Term Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Dual_Eligible_Effective_Date</fullName>
        <field>Dual_Eligible_Attachment_Effective_Date__c</field>
        <formula>Apttus__Contract_Start_Date__c</formula>
        <name>CLM Dual Eligible Effective Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_HCSC_Agreement_Name</fullName>
        <field>Name</field>
        <formula>RecordType.Name &amp; &quot; - &quot; &amp;  IF( Apttus__Account__r.Name == null,  Apttus__Account__r.FirstName + &quot; &quot; +  Apttus__Account__r.MiddleName + &quot; &quot; + Apttus__Account__r.LastName,  Apttus__Account__r.Name  )
 &amp; &quot; - &quot; &amp; ( IF( Apttus__Account__r.CM_Corporate_Entity_Code__c = &quot;IL1&quot;, &quot;BCBSIL&quot;,  IF(Apttus__Account__r.CM_Corporate_Entity_Code__c = &quot;NM1&quot;, &quot;BCBSNM&quot;,  IF(Apttus__Account__r.CM_Corporate_Entity_Code__c = &quot;OK1&quot;, &quot;BCBSOK&quot;,  IF(Apttus__Account__r.CM_Corporate_Entity_Code__c = &quot;TX1&quot;, &quot;BCBSTX&quot;, &quot;BCBSMT&quot;) ) ) ) )</formula>
        <name>CLM - HCSC Agreement Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_HCSC_Agreement_Status_Author</fullName>
        <field>Apttus__Status__c</field>
        <literalValue>Author Contract</literalValue>
        <name>CLM - HCSC Agreement Status: Author</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_HCSC_Agreement_Status_In_Authorin</fullName>
        <field>Apttus__Status_Category__c</field>
        <literalValue>In Authoring</literalValue>
        <name>CLM - HCSC Agreement Status: In Authorin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_HCSC_Agreement_Status_In_Authoring</fullName>
        <field>Apttus__Status_Category__c</field>
        <literalValue>In Authoring</literalValue>
        <name>CLM - HCSC Agreement Status In Authoring</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_HCSC_Resetting_Workflow_trigger</fullName>
        <field>Apttus__Workflow_Trigger_Viewed_Final__c</field>
        <literalValue>0</literalValue>
        <name>CLM - HCSC Resetting Workflow trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_HMO_Attachment_Effective_Date</fullName>
        <field>HMO_Attachment_Effective_Date__c</field>
        <formula>Apttus__Contract_Start_Date__c</formula>
        <name>CLM HMO Attachment Effective Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_IL_Term_Without_Cause_Default</fullName>
        <field>Termination_Without_Cause_Notice__c</field>
        <literalValue>sixty (60) calendar days</literalValue>
        <name>CLM IL Term Without Cause Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Initial_MA_Attch_Term_Years_Default</fullName>
        <field>Initial_MA_Attachment_Term_years__c</field>
        <literalValue>one (1) year</literalValue>
        <name>CLM Initial MA Attch Term Years Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_MA_Attachment_Effective_Date</fullName>
        <field>MA_Attachment_Effective_Date__c</field>
        <formula>Apttus__Contract_Start_Date__c</formula>
        <name>CLM MA Attachment Effective Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_MT_NM_OK_TX_Term_Without_Default</fullName>
        <field>Termination_Without_Cause_Notice__c</field>
        <literalValue>ninety (90) calendar days</literalValue>
        <name>CLM MT, NM, OK, TX Term Without Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Mediation_Default_Illinois</fullName>
        <field>Mediation_City__c</field>
        <literalValue>Chicago, IL</literalValue>
        <name>CLM - Mediation Default Illinois</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Mediation_Default_Montana</fullName>
        <field>Mediation_City__c</field>
        <literalValue>Helena, MT</literalValue>
        <name>CLM - Mediation Default Montana</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Mediation_Default_New_Mexico</fullName>
        <field>Mediation_City__c</field>
        <literalValue>Albuquerque, NM</literalValue>
        <name>CLM - Mediation Default New Mexico</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Medicaid_Attachment_Effective_Date</fullName>
        <field>Medicaid_Attachment_Effective_Date__c</field>
        <formula>Apttus__Contract_Start_Date__c</formula>
        <name>CLM Medicaid Attachment Effective Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Medicare_Select_Attach_Effective_Dat</fullName>
        <field>Medicare_Select_Attachment_Effective_Dat__c</field>
        <formula>Apttus__Contract_Start_Date__c</formula>
        <name>CLM Medicare Select Attach Effective Dat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_NM_Medicaid_Fee_Schedule</fullName>
        <field>of_Medicaid_fee_schedule__c</field>
        <formula>1</formula>
        <name>CLM NM Medicaid Fee Schedule %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Non_Standard_Legal_Language_Reset</fullName>
        <description>Non-Standard Legal Language Reset after regeneration</description>
        <field>Apttus_Approval__Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>CLM Non-Standard Legal Language Reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_PPO_Attachment_Effective_Date</fullName>
        <field>PPO_Attachment_Effective_Date__c</field>
        <formula>Apttus__Contract_Start_Date__c</formula>
        <name>CLM PPO Attachment Effective Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Plan_Attachment_Effective_Date</fullName>
        <field>Plan_Attachment_Effective_Date__c</field>
        <formula>Apttus__Contract_Start_Date__c</formula>
        <name>CLM Plan Attachment Effective Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Populate_Provider_Id</fullName>
        <field>CLM_Provider_ID_Txt__c</field>
        <formula>Apttus__Account__r.Prov_ID__c</formula>
        <name>CLM_Populate Provider Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Set_Agreement_End_Date_on_Renewal</fullName>
        <description>Set the Agreement End Date on Renewal</description>
        <field>Apttus__Contract_End_Date__c</field>
        <formula>ADDMONTHS( Apttus__Contract_End_Date__c , Apttus__Auto_Renew_Term_Months__c )</formula>
        <name>CLM - Set Agreement End Date on Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Set_Approval_Status_Approved</fullName>
        <description>Set the Approval Status to Approved</description>
        <field>Apttus_Approval__Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>CLM - Set Approval Status-Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Set_Approval_Status_Not_Submitted</fullName>
        <description>Set the Approval Status to Not Submitted</description>
        <field>Apttus_Approval__Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>CLM - Set Approval Status-Not Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Update_Approval_Required</fullName>
        <description>Sets the Approval Required to True</description>
        <field>APTS_Approvals_Required__c</field>
        <literalValue>1</literalValue>
        <name>CLM Update Approval Required - True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CLM_Update_Approval_Required_False</fullName>
        <description>Set the Approval Required Field to False</description>
        <field>APTS_Approvals_Required__c</field>
        <literalValue>0</literalValue>
        <name>CLM Update Approval Required - False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Apttus__Reset Clone Trigger</fullName>
        <actions>
            <name>Apttus__SetClonetriggertofalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Workflow_Trigger_Created_From_Clone__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Reset Clone Trigger</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Apttus__Search Field Update</fullName>
        <actions>
            <name>Apttus__SearchFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate an external Id search field with account name, so that side bar support can work with Account name search</description>
        <formula>or(not (isnull(Apttus__Account__r.Name)) ,not (isnull(Apttus__FF_Agreement_Number__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Apttus__Set Agreement Number</fullName>
        <actions>
            <name>Apttus__SetAgreementNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Agreement_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set agreement number for new agreements. The agreement number is auto generated.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM - Arbitration Default Illinois</fullName>
        <actions>
            <name>CLM_Arbitration_Default_Illinois</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Plan__c</field>
            <operation>equals</operation>
            <value>Illinois</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLM - Arbitration Default Montana</fullName>
        <actions>
            <name>CLM_Arbitration_Default_Montana</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Plan__c</field>
            <operation>equals</operation>
            <value>Montana</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM - Arbitration Default New Mexico</fullName>
        <actions>
            <name>CLM_Arbitration_Default_New_Mexico</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Plan__c</field>
            <operation>equals</operation>
            <value>New Mexico</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM - Calculate Initial Term Date Default</fullName>
        <actions>
            <name>CLM_Add_Initial_Term_Months</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_Add_the_Initial_Term_Years</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Facility</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Medical Group</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Non-ASC Ancillary</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Professional</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASC</value>
        </criteriaItems>
        <description>Calculates Initial Term Date = Contract effective date + Initial Term years + Initial Term months</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM - HCSC Agreement Activation</fullName>
        <actions>
            <name>CLM_HCSC_Agreement_Activation_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status_Category__c</field>
            <operation>equals</operation>
            <value>In Effect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLM - HCSC Agreement Approval Approved</fullName>
        <actions>
            <name>CLM_HCSC_Agreement_Approval_Approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus_Approval__Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLM - HCSC Agreement Approval Rejected</fullName>
        <actions>
            <name>CLM_HCSC_Agreement_Approval_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus_Approval__Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLM - HCSC Agreement Expiration</fullName>
        <actions>
            <name>CLM_Agreement_Expiration_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status_Category__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLM - HCSC Agreement Name</fullName>
        <actions>
            <name>CLM_HCSC_Agreement_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASC,Non-ASC Ancillary,Facility,Professional,Medical Group,MCG-Dev</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM - HCSC Agreement Status%3A In Authoring</fullName>
        <actions>
            <name>CLM_HCSC_Agreement_Status_Author</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_HCSC_Agreement_Status_In_Authorin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_HCSC_Resetting_Workflow_trigger</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Workflow_Trigger_Viewed_Final__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLM - HCSC Provider Name</fullName>
        <actions>
            <name>CLM_Account_to_Provider_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASC,Non-ASC Ancillary,Facility,Professional,Medical Group,MCG-Dev</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLM - Mediation Default Illinois</fullName>
        <actions>
            <name>CLM_Mediation_Default_Illinois</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Plan__c</field>
            <operation>equals</operation>
            <value>Illinois</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM - Mediation Default Montana</fullName>
        <actions>
            <name>CLM_Mediation_Default_Montana</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Plan__c</field>
            <operation>equals</operation>
            <value>Montana</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM - Mediation Default New Mexico</fullName>
        <actions>
            <name>CLM_Mediation_Default_New_Mexico</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Plan__c</field>
            <operation>equals</operation>
            <value>New Mexico</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM - Set Approvals Required - False - NM</fullName>
        <actions>
            <name>CLM_Set_Approval_Status_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_Update_Approval_Required_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the Approvals Required to False if none of the conditions are met for Approvals based on the Approval Matrix for New Mexico</description>
        <formula>( (ISPICKVAL(Plan__c, &quot;New Mexico&quot;))  &amp;&amp;    (ISPICKVAL(Apttus__Status_Category__c, &quot;In Authoring&quot;)) &amp;&amp;    (Apttus__Non_Standard_Legal_Language__c  = False    &amp;&amp;      ((ISPICKVAL(New_Provider__c, &quot;no&quot;) || ISBLANK(TEXT(New_Provider__c)))   ||        (ISPICKVAL(Reimb_is_greater_than_5_of_standard__c,&quot;no&quot;) || ISBLANK(TEXT(Reimb_is_greater_than_5_of_standard__c)))    )    &amp;&amp;    (ISPICKVAL(Operational_readiness_approval_required__c,&quot;no&quot;) || ISBLANK(TEXT(Operational_readiness_approval_required__c)))    &amp;&amp;    ( (Dollar_of_increase_per_year__c  &lt;=  5000 || ISNULL(Dollar_of_increase_per_year__c) ) ||      (Dollar_of_increase_per_year__c &gt;= 10000  || ISNULL(Dollar_of_increase_per_year__c) ) ||      (Percent_of_increase_per_year__c &gt;= 10    || ISNULL(Percent_of_increase_per_year__c) )    )    &amp;&amp;     ( (Dollar_of_increase_per_year__c &lt;= 10000  || ISNULL(Dollar_of_increase_per_year__c) ) ||      (Dollar_of_increase_per_year__c &gt;= 50000  || ISNULL(Dollar_of_increase_per_year__c) ) ||      (Percent_of_increase_per_year__c  &lt;= 5    || ISNULL(Percent_of_increase_per_year__c) ) ||      (Percent_of_increase_per_year__c &gt;= 10    || ISNULL(Percent_of_increase_per_year__c) )    )    &amp;&amp;    ( (Percent_of_increase_per_year__c  &lt;= 10   || ISNULL(Percent_of_increase_per_year__c) ) ||        (Percent_of_increase_per_year__c  &gt;= 15   || ISNULL(Percent_of_increase_per_year__c) )    )    &amp;&amp;    ( (Dollar_of_increase_per_year__c &lt;= 100000 || ISNULL(Dollar_of_increase_per_year__c) ) ||      (Percent_of_increase_per_year__c &lt;= 15    || ISNULL(Percent_of_increase_per_year__c) )    )    &amp;&amp;      (ISPICKVAL(Rate_Adjustment_Escalators__c, &quot;no&quot;) || ISBLANK(TEXT(Rate_Adjustment_Escalators__c)))    &amp;&amp;    (ISPICKVAL(Reimbursement_approval_required__c,&quot;no&quot;) || ISBLANK(TEXT(Reimbursement_approval_required__c)))    &amp;&amp;    (ISPICKVAL(Was_Market_Analysis_Done__c, &quot;no&quot;) || ISBLANK(TEXT(Was_Market_Analysis_Done__c)))   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLM - Set Approvals Required - False- IL-OK-MT-TX</fullName>
        <actions>
            <name>CLM_Set_Approval_Status_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_Update_Approval_Required_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the Approvals Required to False if the conditions are not met for Approvals based on the Approval Matrix for Illinois, Montana, Oklahoma &amp; Texas</description>
        <formula>( ((ISPICKVAL(Plan__c, &quot;Illinois&quot;)) ||     (ISPICKVAL(Plan__c, &quot;Montana&quot;)) ||    (ISPICKVAL(Plan__c, &quot;Oklahoma&quot;)) ||    (ISPICKVAL(Plan__c, &quot;Texas&quot;)) ) &amp;&amp;    (ISPICKVAL(Apttus__Status_Category__c, &quot;In Authoring&quot;))  &amp;&amp;    (Apttus__Non_Standard_Legal_Language__c  = False     &amp;&amp;  (ISPICKVAL(Operational_readiness_approval_required__c,&quot;no&quot;) || ISBLANK(TEXT(Operational_readiness_approval_required__c)))    &amp;&amp;    (ISPICKVAL(Reimbursement_approval_required__c,&quot;no&quot;) || ISBLANK(TEXT(Reimbursement_approval_required__c)))      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLM - Set Approvals Required - True - IL-OK-MT-TX</fullName>
        <actions>
            <name>CLM_Set_Approval_Status_Not_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_Update_Approval_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the Approvals Required to True if the conditions are met for Approvals based on the Approval Matrix for Illinois, Montana, Oklahoma &amp; Texas</description>
        <formula>( ((ISPICKVAL(Plan__c, &quot;Illinois&quot;)) ||     (ISPICKVAL(Plan__c, &quot;Montana&quot;)) ||    (ISPICKVAL(Plan__c, &quot;Oklahoma&quot;)) ||    (ISPICKVAL(Plan__c, &quot;Texas&quot;)) ) &amp;&amp;    (ISPICKVAL(Apttus__Status_Category__c, &quot;In Authoring&quot;)) &amp;&amp;    (APTS_Approvals_Required__c = False) &amp;&amp;    (Apttus__Non_Standard_Legal_Language__c  = True       ||   ISPICKVAL(Operational_readiness_approval_required__c,&quot;yes&quot;)     ||     ISPICKVAL(Reimbursement_approval_required__c,&quot;yes&quot;)      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLM - Set Approvals Required - True - NM</fullName>
        <actions>
            <name>CLM_Set_Approval_Status_Not_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_Update_Approval_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the Approvals Required to True if the conditions are met for Approvals based on the Approval Matrix for New Mexico</description>
        <formula>( (ISPICKVAL(Plan__c, &quot;New Mexico&quot;))  &amp;&amp;    (ISPICKVAL(Apttus__Status_Category__c, &quot;In Authoring&quot;)) &amp;&amp;    (APTS_Approvals_Required__c = False) &amp;&amp;    (Apttus__Non_Standard_Legal_Language__c  = True      ||     (ISPICKVAL(New_Provider__c, &quot;yes&quot;)  &amp;&amp;       ISPICKVAL(Reimb_is_greater_than_5_of_standard__c,&quot;yes&quot;)     )    ||   ISPICKVAL(Operational_readiness_approval_required__c,&quot;yes&quot;)   ||     (Dollar_of_increase_per_year__c &gt; 5000  &amp;&amp;      Dollar_of_increase_per_year__c &lt; 10000  &amp;&amp;      Percent_of_increase_per_year__c &lt; 10)    ||     (Dollar_of_increase_per_year__c &gt; 10000  &amp;&amp;      Dollar_of_increase_per_year__c &lt; 50000  &amp;&amp;      Percent_of_increase_per_year__c  &gt; 5  &amp;&amp;      Percent_of_increase_per_year__c &lt; 10)    ||     (Percent_of_increase_per_year__c  &gt; 10  &amp;&amp;      Percent_of_increase_per_year__c  &lt; 15)    ||     (Dollar_of_increase_per_year__c &gt; 100000  &amp;&amp;      Percent_of_increase_per_year__c  &gt; 15)    ||     (ISPICKVAL(Rate_Adjustment_Escalators__c, &quot;yes&quot;))    ||     (ISPICKVAL(Reimbursement_approval_required__c,&quot;yes&quot;))    ||     (ISPICKVAL(Was_Market_Analysis_Done__c, &quot;yes&quot;))   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CLM Agreement Reminders</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status_Category__c</field>
            <operation>equals</operation>
            <value>In Effect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status__c</field>
            <operation>notEqual</operation>
            <value>Superseded</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Apttus__APTS_Agreement__c.Inflator_Review_Date__c</offsetFromField>
            <timeLength>-180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CLM_HCSC_Agreement_90_Day_Expiration_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CLM Agreement Termination</fullName>
        <actions>
            <name>CLM_HCSC_Agreement_Termination_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status_Category__c</field>
            <operation>equals</operation>
            <value>Terminated</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLM Approval Cancelled</fullName>
        <actions>
            <name>CLM_Approval_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus_Approval__Approval_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>Workflow process for Approvals that are cancelled</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLM Auto Renewal</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Auto_Renewal__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status_Category__c</field>
            <operation>equals</operation>
            <value>In Effect</value>
        </criteriaItems>
        <description>Workflow process for Auto Renewal for Agreements that are marked for Auto Renewal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CLM_Auto_Renewal_Email_Notification</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>CLM_Set_Agreement_End_Date_on_Renewal</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CLM Auto Renewal Notice</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Auto_Renewal__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status_Category__c</field>
            <operation>equals</operation>
            <value>In Effect</value>
        </criteriaItems>
        <description>Workflow process for Auto Renewal Notice for Agreements that are marked for Auto Renewal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CLM_Auto_Renewal_Notice</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Renewal_Notice_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CLM Effective Dates</fullName>
        <actions>
            <name>CLM_Defaul_for_Attachment_Effective_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_Dual_Eligible_Effective_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_HMO_Attachment_Effective_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_MA_Attachment_Effective_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_Medicaid_Attachment_Effective_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_Medicare_Select_Attach_Effective_Dat</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_PPO_Attachment_Effective_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CLM_Plan_Attachment_Effective_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Facility,Medical Group,Non-ASC Ancillary,Professional,ASC</value>
        </criteriaItems>
        <description>Set default field values Attachment Effective Dates</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM IL Field Updates</fullName>
        <actions>
            <name>CLM_IL_Term_Without_Cause_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Plan__c</field>
            <operation>equals</operation>
            <value>Illinois</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM MT%2C NM%2C OK%2C TX Field Updates</fullName>
        <actions>
            <name>CLM_MT_NM_OK_TX_Term_Without_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Plan__c</field>
            <operation>equals</operation>
            <value>Montana,New Mexico,Oklahoma</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM NM Field Updates</fullName>
        <actions>
            <name>CLM_NM_Medicaid_Fee_Schedule</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Plan__c</field>
            <operation>equals</operation>
            <value>New Mexico</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CLM Regeneration Reset</fullName>
        <actions>
            <name>CLM_Non_Standard_Legal_Language_Reset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__FF_Regenerate_Agreement__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Rule will take effect when a document has been regenerated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLM Review Task</fullName>
        <actions>
            <name>CLM_HCSC_Agreement_Termination_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CLM_Review_Task</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__FF_Send_To_Other_Party_For_Review__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status__c</field>
            <operation>equals</operation>
            <value>Other Party Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CLM_Populate Provider Id</fullName>
        <actions>
            <name>CLM_Populate_Provider_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1==1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>CLM_Review_Task</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>CLM Review Task</subject>
    </tasks>
</Workflow>
