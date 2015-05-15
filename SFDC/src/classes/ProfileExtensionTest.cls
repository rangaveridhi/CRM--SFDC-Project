@isTest //(SeeAllData=true)

public class ProfileExtensionTest{

   private static testmethod void profileextntest11(){
   
   PageReference pg= Page.profileExtension;
   Test.setCurrentPage(pg);
   
   //System.currentPageReference().getParameters().put('accountName','test Acccount Name');
   Account acc= new Account(Name='testacc');
   insert acc;
       Account acc1= new Account(Name='testcaaacd');
   insert acc1;
   List<Contact> conList= new List<Contact>();
   Contact con = new Contact(FirstName='test',LastName='test1');
   con.AccountId=acc.Id;
   con.Country__c='India';
   Contact con1 = new Contact(FirstName='test',LastName='test1');
   con1.AccountId=acc.Id;
       Contact con2 = new Contact(FirstName='test',LastName='test2');
       Contact con3 = new Contact(FirstName='test',LastName='test3');
   //con2.AccountId=acc.Id;
   conList.add(con);
   conList.add(con1);
       conList.add(con2);
        conList.add(con3);
   Test.startTest();
   insert conList;
   Test.stopTest();
   for(Integer j=0;j<conList.size();j++){
   ApexPages.StandardController sc = new ApexPages.standardController(conList.get(j));
  
   
   ProfileExtension pfEx=new ProfileExtension(sc);
   pfEx.closePopup();
   pfEx.showPopup();
   List<String> accList= new List<String>();
   accList.add('test Account contactid');
   accList.add('test CustomRelation');
       accList.add('syncDataPage');
   accList.add('');
   
   for(Integer i=0;i<accList.size();i++){
   System.currentPageReference().getParameters().put('retURL',accList.get(i));
   pfEx.save();
   pfEx.saveAccount();
   pfEx.populateCountryCode();
   pfEx.accountName=accList.get(i);
   }
    }
   
   
   
   }

}