@isTest
private class TestAutoPriorityParentCase { 
    
    @testSetup static void prepareData() {
	    GlobalSettings__c gs	=	new GlobalSettings__c();
        gs.name 				=	'PFFileRecieved';
        gs.PFFileRecieved__c	=	false;
        gs.Record_Type_Names__c	=	'Master_Provider_Case_data;Provider_On_boarding;PDM;CRM';
        insert gs;
        
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
        
    }  
    public static List<case> createCaseHierarchy(){
        List<case> CasePriorities = new List<case>(); 
        List<case> masterCase = new List<case>();
        Case  mCase = TestCaseUtil.CreateCase();
        Case  mCase1 = TestCaseUtil.CreateCase();
        masterCase.add(mCase);
        insert masterCase;
        if(AvoidRecursion.hasRunBeforeAlready()){
     		CreateChildCase.createChildCaseMethod(masterCase); 
     	}
        CasePriorities = [Select Id, Priority, parentId From Case where parentId = :mCase.Id];
        return CasePriorities;
    }
    public static List<case> createPriorityCase(){
        List<case> CasePriorities = new List<case>(); 
        List<case> masterCase = new List<case>();
        Case  mCase = TestCaseUtil.CreateCase();
        masterCase.add(mCase);
        insert masterCase;
        CasePriorities = [Select Id, Priority,ParentId From Case where Id = :mCase.Id limit 1];
        return CasePriorities;
    }
    public static List<case> createPriorityCaseHierarchy(){
        List<case> CasePriorities = new List<case>(); 
        List<case> masterCase = new List<case>();
        Case  mCase = TestCaseUtil.CreateCase();
        masterCase.add(mCase);
        insert masterCase;
        if(AvoidRecursion.hasRunBeforeAlready()){
     		CreateChildCase.createChildCaseMethod(masterCase); 
     	}
        CasePriorities = [Select Id, Priority, parentId From Case where parentId = :mCase.Id];
        return masterCase;
    }

	public static testMethod void testParentPriority() {
        Test.startTest();
        Set<Id> parentCaseIdSet =  new Set<Id>();
        List<case> mmCase = createCaseHierarchy();
		for (Case c:mmCase) {
			if (c.ParentId!=null) {
				c.Priority = 'High';
                parentCaseIdSet.add(c.ParentId);
		        AvoidRecursion.runAfter = false;
			}
		}
        AvoidRecursion.runBefore = false;
        update mmCase;
       
		for (Case c:mmCase) {
			if (c.ParentId!=null) {
				c.Priority = 'Medium';
                parentCaseIdSet.add(c.ParentId);
                AvoidRecursion.runAfter = false;
            }			
		}
        AvoidRecursion.runBefore = false;
        update mmCase;
        
        for (Case c:mmCase) {
			if (c.ParentId!=null) {
				c.Priority = 'Low';
                parentCaseIdSet.add(c.ParentId);
                AvoidRecursion.runAfter = false;
			}
		}
        AvoidRecursion.runBefore = false;
        update mmCase;
       
       /* mmCase = createPriorityCase();
		for (Case c:mmCase) {
			if (c.ParentId ==null) {
				c.Priority = 'High';
                parentCaseIdSet.add(c.ParentId);
		        AvoidRecursion.runAfter = false;
			}
		}
        AvoidRecursion.runBefore = false;
        update mmCase;
        
        for (Case c:mmCase) {
			if (c.ParentId==null) {
				c.Priority = 'Medium';
                parentCaseIdSet.add(c.ParentId);
                AvoidRecursion.runAfter = false;
			}			
		}
        AvoidRecursion.runBefore = false;
        update mmCase;
        
        for (Case c:mmCase) {
			if (c.ParentId==null) {
				c.Priority = 'Low';
                parentCaseIdSet.add(c.ParentId);
                AvoidRecursion.runAfter = false;
			}
		}
        AvoidRecursion.runBefore = false;
        update mmCase; */
        Test.stopTest();
    }
    public static testMethod void testParentPriorityErro() {
       Test.startTest();
        Set<Id> parentCaseIdSet =  new Set<Id>();
        List<case> mmCase = createPriorityCaseHierarchy();
		//Update one of the children and see that the parent stays open 
		/*for (Case c:mmCase) 
        {
			if (c.ParentId==null) 
            {
				c.Priority = 'High';
		        AvoidRecursion.runAfter = false;
			}
		} */
        
        for( Case c : mmCase )
        {
            parentCaseIdSet.add( c.ParentId );
        }
        List<Case> tempList = [Select id from case where parentId IN :parentCaseIdSet ];
        List<Case> tempList1 = new List<Case>();
        for( Case c1 : tempList )
        {
            Case C2 = new Case( Id = c1.Id );
            c2.Priority = 'high';
            tempList1.add( c2 );
        }
            
        AvoidRecursion.runBefore = false;
        update tempList1;
        update mmCase;
       
        Test.stopTest();
    }
    /*public static testMethod void testDeleteParentPriority() {
        List<case> mmCase = createPriorityCase();
       Test.startTest();
        Set<Id> parentCaseIdSet =  new Set<Id>();
        delete mmCase;
        Test.stopTest();
    }*/
}