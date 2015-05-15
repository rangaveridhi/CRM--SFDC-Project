public class accountOppsExtension {

     private final Account acc;
    public List<Account> listAccount {get;set;}
    public List<Opportunity> listOpps {get;set;}
    public List<Account> listClosedAccount {get;set;}
    public List<Opportunity> listClosedOpps {get;set;}
    public List<Account> listBoughtAccount {get;set;}
    public List<Opportunity> listBoughtOpps {get;set;}
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public accountOppsExtension (ApexPages.StandardController stdController) {
        this.acc = (Account)stdController.getRecord();
        listAccount = [Select Id,(Select Id,Name,StageName,closeDate,CreatedById,contact__r.name from Opportunities where Availability_Status__c= TRUE and StageName NOT IN ('Bought','Lost')) from Account where Id =: acc.id];
        listOpps =  listAccount.get(0).Opportunities;
        listClosedAccount = [Select Id,(Select Id,Name,StageName,closeDate,CreatedById,contact__r.name from Opportunities where Availability_Status__c= false) from Account where Id =: acc.id];
        if(listClosedAccount!=null && listClosedAccount.size()>0){
        listClosedOpps =  listClosedAccount.get(0).Opportunities;
        }
        listBoughtAccount = [Select Id,(Select Id,Name,StageName,closeDate,CreatedById,contact__r.name from Opportunities where Availability_Status__c= TRUE and StageName ='Bought') from Account where Id =: acc.id];
        if(listBoughtAccount!=null && listBoughtAccount.size()>0){
        listBoughtOpps = listBoughtAccount.get(0).Opportunities;
        }
    
    
    }
    
   
        
    
}