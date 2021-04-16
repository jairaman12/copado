@isTest

public class UserTestData {
    
    @testSetup @testvisible static  void UserCreation()
    {
            String UserName;
            Profile ProfileRecord = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User UserInsert = new User();
            UserInsert.Alias='prov';
            UserInsert.Email='standarduser@testorg.com.Test1';
            UserInsert.EmailEncodingKey='UTF-8';
            UserInsert.LastName ='Testing';
            UserInsert.LanguageLocaleKey='en_US';
            userInsert.TimeZoneSidKey='America/Los_Angeles';
            userInsert.UserName='standarduser@testorg.com.providerIntake';
            userInsert.LocaleSidKey='en_US';
             UserInsert.ProfileId=ProfileRecord.Id;
            UserInsert.IsActive=true;
            insert   userInsert;  
            List<User> UsertValues = new List<User>();
            UsertValues=[select Id,Username from user where Id=:userInsert.Id];
            for(User TestUser_Values :UsertValues)
            {
              UserName= TestUser_Values.userName;  
            }
    }

}