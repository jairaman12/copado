<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NotifySFIssueLogCreatorOnClose</fullName>
        <description>Notify SF Issue Log Creator On Close</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Provider_PIER_Network/NotificationOnSFIssueLogClose</template>
    </alerts>
</Workflow>
