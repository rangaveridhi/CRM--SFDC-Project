@istest
public class triggerFamilyHeadUpdateTest{
    static testmethod void unittest(){
Test.startTest();
        Account acc= new Account();
        acc.Name='Test Account';
        insert acc;
        contact c=new contact();
        c.lastname='greg';
        c.AccountId=acc.Id;
        insert c;
     
   Test.stopTest();
           
        }
    
}