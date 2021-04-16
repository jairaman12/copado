public class EmailToCaseOwnerUpdate {
    
    @InvocableMethod(label='EmailToCaseOwnerUpdate' description='Returns the list of account names corresponding to the specified account IDs.')
    public static void updateEmailCaseOwner(list<Case> caseList)
    {
        System.debug('caseList in side Process builder===>>>'+caseList.size());
        list<OMNICriteriaTable> criteria = new list<OMNICriteriaTable>();
        Datetime GMTDate            =   system.now();
        String strConvertedDate     =   GMTDate.format('yyyy-MM-dd','America/Chicago');
        String strConvertedDate2    =   GMTDate.format('yyyy-MM-dd HH:mm:ss','America/Chicago');
        Datetime dttm               =   DateTIME.valueof(strConvertedDate2);
        Date dt                     =   Date.valueof(strConvertedDate);
        OMNICriteriaTable temp      =   new OMNICriteriaTable();
        
        list<OMNI_Queue__c> q       =   [select id,Ownerid,Case_Type__c,Plan_Id__c,Queue_Priority__c,Case_Type_Name_Origin__c,
                                         Request_Type_s__c from OMNI_Queue__c where Case_Type__c='Email'];
        list<OMNI_User_Group__c> UGlist = [select id,Group__c,Selected_User_Ids__c,Selected_Users__c,User__c from OMNI_User_Group__c 
                                           where Active__c = true and Start_Date__c <= :dt and End_Date__c >= :dt and 
                                           Week_Days__c includes (:dttm.format('EEEE'))];
        
        Map<id,OMNI_User_Group__c> userMap = new Map<id,OMNI_User_Group__c>();
        
        for(OMNI_User_Group__c g: UGlist)
        {       
            userMap.put(g.Group__c,g);
        }
       
        for(OMNI_Queue__c t : q) 
        {
            temp        =   new OMNICriteriaTable();
            temp.Queue  =   t;
            temp.UserGroup = userMap.get(t.id);
            criteria.add(temp);
        }    
        List<Case> casesToUpdate = new List<Case>();
        for( Case aCase : (List<Case>) caseList )
        {
            System.debug('Cases processed in Batch====>'+aCase.Subject);
            for( OMNI_Queue__c omniQueue : q )
            {
                Set<String> tempSet = new Set<String>();
               tempSet.addAll(String.valueOf( omniQueue.Case_Type_Name_Origin__c ).split(';')); 
                    if( tempSet.contains( aCase.Origin ) 
                       && omniQueue.Plan_Id__c == aCase.Plan_ID__c 
                      )
                    {
                           Case tempCase = new Case(Id=aCase.Id);
                           tempCase.ownerid = omniQueue.ownerid;
                           casesToUpdate.add(tempCase);
                           break;                           
                    }else{
                        System.debug('<<<==== No Cases for Update ====>>>');
                    }
             }
            /*for(OMNICriteriaTable t:criteria)
            {     
                    Set<String> tempSet = new Set<String>();
                    tempSet.addAll(String.valueOf(t.Queue.Case_Type_Name_Origin__c).split(';')); 
                    
                    if( tempSet.contains(aCase.Origin) 
                       && t.Queue.Plan_Id__c == aCase.Plan_ID__c 
                       && t.UserGroup != null
                      )
                    {
                           Case tempCase = new Case(Id=aCase.Id);
                           tempCase.ownerid = t.Queue.ownerid;
                           casesToUpdate.add(tempCase);
                           break;                           
                    }else{
                        System.debug('<<<==== No Cases for Update ====>>>');
                    }
                } */
            
            
        }
        System.debug('casesToUpdate===>'+casesToUpdate);
        if(!casesToUpdate.isEmpty())
        {
            try{
                update casesToUpdate;
            }catch(Exception e){
               System.debug('Error while updating Email -to Case owner update when OMNi custom queue found===>>>'+e.getMessage());
            }
            
        } 
    }
}