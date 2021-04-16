public class OMNIReservedQueueManagementCls
{
    public String                   selectedReserveQueue        {set; get;} 
    /*public List<SelectOption>       reservedQueueOption         {set; get;}
    public List<SelectOption>       leftOptions                 {set; get;}
    public List<SelectOption>       rightOptions                {set; get;} */
    
    public SelectOption[]           reservedQueueOption         {set; get;}
    public SelectOption[]           leftOptions                 {set; get;}
    public SelectOption[]           rightOptions                {set; get;}
    public Boolean                  isDisplay                   {set; get;}
    public String                   planId = '';
    public List<User> userList                      =   new List<User>();
    public Map<String,Id> userNameAndIdMap          =   new Map<String,Id>();
    public Set<String>  queueNames                  =   new Set<String>();
    public List<OMNI_Queue__c> reserQueueList       =   new List<OMNI_Queue__c>();
    public Map<String,OMNI_Queue__c> reservQueueMap =   new Map<String,OMNI_Queue__c>();
    public Map<String,Reserved_Queues_With_PlanId__mdt> rqMap = new Map<String,Reserved_Queues_With_PlanId__mdt>();
    
    public  List<Reserved_Queues_With_PlanId__mdt> reservedQueueList;
    
    public OMNIReservedQueueManagementCls(OMNIQueueManagementCls controller)
    {
        
        system.debug('controller.planId===>>>'+controller.planId);
        system.debug('selectedCaseType===>>>'+controller.selectedCaseType);
        reservedQueueOption             =   new List<SelectOption>();
        leftOptions                     =   new List<SelectOption>();
        rightOptions                    =   new List<SelectOption>();
        isDisplay                       =   false;
        planId                          =   controller.planId;                  
        String requestTypeQueryStr      =   'SELECT ' + Utils.getObjectFieldList('Reserved_Queues_With_PlanId__mdt') +' FROM Reserved_Queues_With_PlanId__mdt';
        requestTypeQueryStr             =   requestTypeQueryStr + ' where Plan_Id__c like \'%' + controller.planId + '%\'';
        reservedQueueList               =   (List<Reserved_Queues_With_PlanId__mdt>)Database.query( requestTypeQueryStr );
        
        
        if(!reservedQueueList.isEmpty())
        {
            for( Reserved_Queues_With_PlanId__mdt record : reservedQueueList )
            {
                if( record.Plan_Id__c == controller.planId )
                {
                    queueNames.add(record.Queue_Name__c);
                    reservedQueueOption.add(new SelectOption(record.Queue_Name__c,record.Queue_Name__c));
                    rqMap.put(record.Queue_Name__c, record);
                } 
            }
            reservedQueueOption.sort();
        }
        if(!queueNames.isEmpty())
        {
            reserQueueList  = [Select Id,Name,Plan_Id__c,Reserved_Queue_Users__c
                               from OMNI_Queue__c where Name IN :queueNames ];
            if(!reserQueueList.isEmpty())
            {
                 for(OMNI_Queue__c queueRec : reserQueueList)
                {
                    reservQueueMap.put(queueRec.Name, queueRec);
                }
            }
        }
        System.debug('reservQueueMap11===>>>'+reservQueueMap);
    }
    
    public pageReference processorsForreservedQueue()
    {
        system.debug('selectedReserveQueue===>>>'+selectedReserveQueue);
        leftOptions.clear();
        rightOptions.clear();
       if(selectedReserveQueue!='None')
        { 
        userList                =   OMNIProcessorsDisplayCls.getUsersList(planId,selectedReserveQueue);
        List<String> userNames  =   new List<String>();
        Set<String> usrSet      =   new Set<String>();
        isDisplay = true;        
        reserQueueList  = [Select Id,Name,Plan_Id__c,Reserved_Queue_Users__c
                               from OMNI_Queue__c where Name=:selectedReserveQueue ];
        if(!userList.isEmpty()){
            for( User usr : userList)
            {
                    userNameAndIdMap.put(usr.name,usr.Id);
                    userNames.add(usr.name);
            }
            userNames.sort();
        }
        system.debug('#### userNameAndIdMap ###' + userNameAndIdMap);
        // List if reserved queue has aleredy users
            if(!reserQueueList.isEmpty()){
                for(OMNI_Queue__c queueName : reserQueueList)
                {
                    if(queueName.Name == selectedReserveQueue && String.isNotEmpty(queueName.Reserved_Queue_Users__c))
                    {
                        usrSet.addAll(queueName.Reserved_Queue_Users__c.split(';'));
                        for(String usr : usrSet ){
                            system.debug('#### User ###' + usr);
                            system.debug('### userNameAndIdMap.get(User) ###' + userNameAndIdMap.get(usr));
                            rightOptions.add(new SelectOption(userNameAndIdMap.get(usr),usr));
                        }
                        
                    }
                }
            }            
         
        if(userNames.size()>0)
        {
            for(String names : userNames)
            {   
                if(!usrSet.isEmpty() && !usrSet.contains(names))
                {
                    leftOptions.add(new SelectOption(userNameAndIdMap.get(names),names));
                }else if(usrSet.isEmpty()){
                    leftOptions.add(new SelectOption(userNameAndIdMap.get(names),names));
                }
            }
        }
        System.debug(isDisplay+'leftOptions===>>>'+leftOptions);
    }else{
            isDisplay=false;
        }
        return null;
    }
    
    public pageReference doSave1()
    {
        Boolean Start               =   true;
        String usersSelected        =   '';
        List<Id> prosIds            =    new List<Id>();
        Boolean isExistingQueue     =   false;
        String returnUrl            =   '';
        system.debug('rightOptions====>>>>'+rightOptions);
        System.debug('selectedReserveQueue===>>>>>'+selectedReserveQueue);
        
        OMNI_Queue__c omniQueue;
        if(!reservQueueMap.isEmpty() && reservQueueMap.containsKey(selectedReserveQueue))
        {
            isExistingQueue             =   true;
            omniQueue                   =   new OMNI_Queue__c(Id=reservQueueMap.get(selectedReserveQueue).Id);
        }else{
            omniQueue                    =   new OMNI_Queue__c();  
        }
        
        System.debug('isExistingQueue===>>>'+isExistingQueue);
        if( (isExistingQueue==false && !rightOptions.isEmpty())
           || (isExistingQueue==true && !rightOptions.isEmpty()) 
           || (isExistingQueue==true && rightOptions.isEmpty())
          )
        {
                omniQueue.Name              =   selectedReserveQueue;
                omniQueue.Plan_Id__c        =   planId;
                System.debug('rightOptions===>>>>>'+rightOptions);
                if(!rightOptions.isEmpty())
                {
                    for( SelectOption so : rightOptions ){
                        if(Start) {
                            usersSelected    =   so.getLabel();
                            prosIds.add(so.getValue());
                            Start            =   false;
                        }else{
                            prosIds.add(so.getValue());
                            usersSelected    =   usersSelected+';'+so.getLabel();
                        }
                    }
                }
              
              System.debug('usersSelected===>>>>>'+usersSelected);
              omniQueue.Reserved_Queue_Users__c =   usersSelected;
              if(rqmap != NULL && rqMap.containsKey(selectedReserveQueue))
                  omniQueue.Queue_Priority__c       =   rqMap.get(selectedReserveQueue).Queue_Priority__c;
              upsert omniQueue;
            UpdateProcessors(prosIds,selectedReserveQueue);
           returnUrl  = '/apex/OMNIQueueManagementPage';
        }else if(isExistingQueue==false && rightOptions.isEmpty()){
            System.debug('With in the Error===>>>>>');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select Processors to Save the Queue.'));
            return null;
        }
       
         return (new pagereference(returnUrl).setredirect(true));
    }
    
    @future
    Public static void UpdateProcessors( List<Id> idList, String queueName )
    {
        System.debug('idList====>'+idList);
        System.debug('queueName====>'+queueName);
        List<Group> queueList               =   [SELECT Id,Name,Type FROM Group WHERE Type = 'Queue' and Name=:queueName];
        List<GroupMember> tempMemberList    =   [SELECT Id FROM GroupMember WHERE GroupId=:queueList[0].Id]; 
        delete tempMemberList;
        
        List<GroupMember> memToBeAdded      =   new List<GroupMember>();
              if(!queueList.isEmpty() && !idList.isEmpty())
              {
                  for(Id userId : idList)
                  {
                    GroupMember tempmem = new GroupMember();
                    tempmem.UserOrGroupId = userId;
                    tempmem.GroupId = queueList[0].Id;
                    memToBeAdded.add(tempmem);   
                  }
              }
            if(!memToBeAdded.isEmpty()){
                insert memToBeAdded;
            }
    }
    public pageReference refreshPage1()
    {
        return null;
    }
}