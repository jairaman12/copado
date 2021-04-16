public class DataSupportForCaseTriggerHandler {
    
    public Case insertDataForParentCases(){
        
        //Create a Case to initialize the Extension constructor
        Case parentCase = TestCaseUtil.CreateCase();   
        parentCase.Email_Address_Submitter__c = 'test@test.com';
        parentCase.Govt_Programs__c = true;
        insert parentCase;
        AvoidRecursion.runAfter = false;
        return parentCase;
        
    }
    
    public Case insertDataForChildCases(Case parentCase){
        
        Case childCase = TestCaseUtil.CreateCase();   
        childCase.ParentId = parentCase.id;        
        childCase.Email_Address_Submitter__c = 'test3@test.com';
        childCase.Govt_Programs__c = true;
        insert childCase;       
        AvoidRecursion.runAfter = false;
        return childCase;
    }    
    
    
    public void updateCase(Case uCase, String fieldname, String value){
        
        uCase.put(fieldname, value);  
        try{
        update uCase;
        }catch(Exception e){
           
        }
        AvoidRecursion.runAfter = false;
        
    }     
    public void insertDataForCustomSettings(){
        
        
       insert
      ( 
          	new CaseLockStatus__c
        	(
            	name='Closed Processed', status__c = 'Closed Processed'
            )
        );
                
        
        
        insert
        (
            new CaseProfile__c
        	(
            	name='System Administator', ProfileName__c = 'System Administrator'
            )                      
        );
        
        insert
        (    
           new CaseProfile__c
        	(
            	
                name='ClosedCaseBypass', ProfileName__c = 'Supervisor,Montana Supervisor'
            )  
        );
        
        insert
        (
            new CaseLockStatus__c
            (
                 name='ClosedCaseStatuses', status__c = 'Closed,Closed Processed,Closed Rejected'                
                //name='ClosedCaseStatuses', status__c = 'Closed,Closed Processed,Closed Rejected'                
            )
         );   
        
        
        insert
        (
            new Email_Settings__c
            (
                 name='URL', state__c = 'http://prodevmer-hcscproviderintake.cs71.force.com'                              
            )
         );           
        
        insert
        (
            new Email_Settings__c
            (
                 name='IL', state__c = 'Netops_Provider_Update@bcbsil.com'                              
            )
         );   


        List<RoleAndPlanId_Settings__c> lst = new List<RoleAndPlanId_Settings__c>();
        
        RoleAndPlanId_Settings__c rp	=	new RoleAndPlanId_Settings__c( Name='Illinois_Supervisor',PlanId__c='IL1',Role_Id__c='00E41000000bXVsEAM' );
        lst.add(rp);
        RoleAndPlanId_Settings__c rp1	=	new RoleAndPlanId_Settings__c( Name='Montana_Supervisor',PlanId__c='MT1',Role_Id__c='00E41000000bXVtEAM' );
        lst.add(rp1);
        RoleAndPlanId_Settings__c rp2	=	new RoleAndPlanId_Settings__c( Name='New_Mexico_Supervisor',PlanId__c='NM1',Role_Id__c='00E41000000bXVuEAM' );
        lst.add(rp2);
        RoleAndPlanId_Settings__c rp3	=	new RoleAndPlanId_Settings__c( Name='Oklahoma_Supervisor',PlanId__c='OK1',Role_Id__c='00E41000000bXVvEAM' );
        lst.add(rp3);
        RoleAndPlanId_Settings__c rp4	=	new RoleAndPlanId_Settings__c( Name='Texas_Supervisor',PlanId__c='TX1',Role_Id__c='00E41000000bXW1EAM' );
        lst.add(rp4);
                               
        insert lst;
        
          List<QueueIds__c>	 queueIdsLst	   = new List<QueueIds__c>();
          QueueIds__c qid1		=	new QueueIds__c(name='IL Contracting Queue',PlanId__c='IL1',QueueId__c='a084D000000Jz9eQAC');
          queueIdsLst.add(qid1);
          QueueIds__c qid2		=	new QueueIds__c(name='Montana Queue',PlanId__c='MT1',QueueId__c='a084D000000Jz9jQAC');
          queueIdsLst.add(qid2);
          QueueIds__c qid3		=	new QueueIds__c(name='Illinois Queue',PlanId__c='IL1',QueueId__c='a084D000000Jz9ZQAS');
          queueIdsLst.add(qid3);
          
          insert queueIdsLst;

        List<CaseOwnerUpdate__c> ownerlst = new List<CaseOwnerUpdate__c>();
        CaseOwnerUpdate__c ownerrp1	=	new CaseOwnerUpdate__c( Name='Montana Supervisor',Profile__c='Montana Supervisor');
        ownerlst.add(ownerrp1);
        CaseOwnerUpdate__c ownerrp2=	new CaseOwnerUpdate__c( Name='Supervisor',Profile__c='Supervisor');
        ownerlst.add(ownerrp2);
        insert ownerlst;
    
    }    
    
    
    
    
}