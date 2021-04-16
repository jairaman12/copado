@isTest
private class TestAutoCloseParentCase {  
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
        List<case> CaseStatuss = new List<case>(); 
        List<case> masterCase = new List<case>();
        Case  mCase = TestCaseUtil.CreateCase();
        masterCase.add(mCase);
        insert masterCase;
        if(AvoidRecursion.hasRunBeforeAlready()){
     		CreateChildCase.createChildCaseMethod(masterCase); 
     	}
        CaseStatuss = [Select Id, Status, parentId From Case where parentId = :mCase.Id];
        return CaseStatuss;
    }
   public static testMethod void testCloseParent() {
        Test.startTest();
        Set<Id> parentCaseIdSet =  new Set<Id>();
        List<case> mmCase = createCaseHierarchy();
		//Update one of the children and see that the parent stays open 
		for (Case c:mmCase) {
			if (c.ParentId!=null) {
				c.Status = 'In Progress';
                parentCaseIdSet.add(c.ParentId);
                AvoidRecursion.runAfter = false;        		
			}
		}
        AvoidRecursion.runBefore = false;
        update mmCase;
        Test.stopTest();
    }
}