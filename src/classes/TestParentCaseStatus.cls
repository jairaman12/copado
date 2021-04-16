@isTest
private class TestParentCaseStatus
{  
     @testSetup 
    static void prepareData()
    {
        
         List<RecordType_settings__c> rtsList	=	 new List<RecordType_settings__c>();
        List<RecordType> recordTypeList	= [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType];
        for( RecordType recType : recordTypeList  )
        {
            RecordType_settings__c rts 	=	new RecordType_settings__c();
            rts.name					=	recType.Id;
            rts.DeveloperName__c	   	=	recType.DeveloperName;
            rts.Name__c					=	recType.Name;
            rts.Record_type_Id__c		=	recType.Id;
            rts.sObject_Type__c			=	recType.SobjectType;
            rtsList.add(rts);
        }
        insert rtsList;
        
         GlobalSettings__c gs	=	new GlobalSettings__c();
        gs.name 				=	'PFFileRecieved';
        gs.PFFileRecieved__c	=	false;
        gs.Record_Type_Names__c	=	'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
          CaseProfile__c cp    =    new CaseProfile__c();
          cp.Name              =    'System Administrator';
          cp.ProfileName__c    =    'System Administrator';
          insert cp;
          
          CaseLockStatus__c cls     =    new CaseLockStatus__c();
          cls.Status__c             =    'Prod Verification';
          cls.Name                  =    'Prod Verification';
          insert cls;
          
           CaseLockStatus__c cls1     =    new CaseLockStatus__c();
          cls1.Status__c             =    'Closed Processed';
          cls1.Name                  =    'Closed Processed';
          insert cls1;
          
          List<QueueIds__c>	 queueIdsLst	   = new List<QueueIds__c>();
          QueueIds__c qid1		=	new QueueIds__c(name='IL Contracting Queue',PlanId__c='IL1',QueueId__c='00G3C000000hOCTUA2');
          queueIdsLst.add(qid1);
          QueueIds__c qid2		=	new QueueIds__c(name='Montana Queue',PlanId__c='MT1',QueueId__c='	00G3C000000IcTaUAK');
          queueIdsLst.add(qid2);
          QueueIds__c qid3		=	new QueueIds__c(name='Illinois Queue',PlanId__c='IL1',QueueId__c='00G3C000000IcTZUA0');
          queueIdsLst.add(qid3);
          
          insert queueIdsLst; 
    }
    
    public static List<case> createCaseHierarchy()
    {
        List<Case> CaseStatuss  =   new List<Case>(); 
        List<Case> masterCase   =   new List<Case>();
        
	        Case  mCase             =   TestCaseUtil.CreateCase();
        masterCase.add ( mCase );
        insert masterCase;
        
        if(AvoidRecursion.hasRunBeforeAlready())
        {
            CreateChildCase.createChildCaseMethod( masterCase ); 
        }
        CaseStatuss = [ Select Id, Status, parentId From Case where Id = :mCase.Id ];
        return CaseStatuss;
    }
    
    public static testMethod void testcaseComments() 
    {
    	
     	List<User> u = TestCaseUtil.createUser('Supervisor','Illinois Supervisor',1);
     	insert u;
        Test.startTest();
         System.runAs( u[0] ) {
            List<case> mmCase   =   createCaseHierarchy();

            CaseComment cc      =   new CaseComment( ParentId = mmCase[0].Id,CommentBody = 'test' );
            insert cc;
            mmCase[0].Status='In Progress';
            update mmCase[0];
            update cc;
            delete cc;
            EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 ', ParentId = mmCase[0].Id)); 
            insert newEmail;
            update newEmail;
            try{
            delete newEmail;
            }catch(Exception e){}
         }
        Test.stopTest();
    }
    
    public static testMethod void testcaseComments_ProdVerification() 
    {
    	
    	User u = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
         LastName = 'last',
         Email = 'puser000@bcbsil.com',
         Username = 'testuser123@bcbsil.com',
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
     	);
     
     	insert u; 
        Test.startTest();
        List<case> mmCase   =   createCaseHierarchy();
		mmCase[0].Status='Prod Verification';
        update mmCase[0];
        System.debug(mmCase[0].parentId);
         //System.runAs( u ) 
         //{
            CaseComment cc      =   new CaseComment( ParentId = mmCase[0].Id,CommentBody = 'test' );
            insert cc;
            cc.CommentBody = 'test1';
            update cc;
            
            delete cc;
            EmailMessage[] newEmail = new EmailMessage[0];
            newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 ', ParentId = mmCase[0].Id)); 
            insert newEmail;
            update newEmail; 
           // System.assertEquals(false, ApexPages.hasMessages(),'Comments can not be deleted once case is set to Prod Verificatoin.');
         //}
        Test.stopTest();
    }
    
    public static testMethod void testParentStatusError() 
    {
       Test.startTest();
           List<case> mmCase    =   createCaseHierarchy();
           mmCase[0].Status     =   'In Progress';
        
            //Update one of the children and see that the parent stays open 
            for( Case c : mmCase ) 
            {
                 System.debug('===>>>c.Status'+c.Status);
                if ( c.ParentId == null ) 
                {
                    c.Status                =   'Closed Processed';
                    c.External_Comments__c  =   'test comments';
                    AvoidRecursion.runAfter =   false;
                }
            }
            AvoidRecursion.runBefore    =   false;
            try{
            update mmCase;
             }catch(Exception e){}
       
        Test.stopTest();
    } 
    private static testMethod void testDelete()
	{
        EmailMessageTriggerHandler EmTrigger = new EmailMessageTriggerHandler();
        List<case> mmCase   =   createCaseHierarchy();      
        CaseComment ccR      =   new CaseComment( ParentId = mmCase[0].Id,CommentBody = 'test' );       
        insert ccR;
        test.startTest();
        EmTrigger.beforeDelete(ccR);
        EmTrigger.afterDelete(ccR);
        Test.stopTest();
        }

    /*public static testMethod void testParentStatusError() 
    {
       Test.startTest();
           List<Case> mmCase    =   createCaseHierarchy();
           List<Case> tempList  =   new List<Case>();
           System.debug('===>>>mmCase'+mmCase.size());
            //Update one of the children and see that the parent stays open 
            for( Case c : mmCase ) 
            {
                if ( c.ParentId == null ) 
                { 
                    Case cas    =   new Case( Id = c.Id );
                    cas.Status = 'Cancelled';
                    AvoidRecursion.runAfter = false;
                    tempList.add( cas );
                }
            } 
            AvoidRecursion.runBefore    =   false;
            update tempList;
        Test.stopTest();
    } */
}