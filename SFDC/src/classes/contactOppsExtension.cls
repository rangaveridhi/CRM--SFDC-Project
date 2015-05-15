public class contactOppsExtension {

     private final Contact con;
    public List<Contact> listContact {get;set;}
    public List<Contact> listClosedContact {get;set;}
    public List<Opportunity> listOpps {get;set;}
    public List<Opportunity> listClosedOpps {get;set;}
    public List<Contact> listBoughtContact {get;set;}
    public List<Opportunity> listBoughtOpps {get;set;}
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public contactOppsExtension (ApexPages.StandardController stdController) {
        this.con= (contact)stdController.getRecord();
        try{
        listContact = [Select Id,(Select Id,Name,StageName,closeDate,CreatedById from Opportunities__r where Availability_Status__c= TRUE and StageName NOT IN ('Bought','Lost')) from contact where Id =: con.id];
        listOpps =  listContact .get(0).Opportunities__r;
        listClosedContact=[Select Id,(Select Id,Name,StageName,closeDate,CreatedById from Opportunities__r where Availability_Status__c= false) from contact where Id =: con.id];
        if(listClosedContact!=null && listClosedContact.size()>0){
            listClosedOpps=listClosedContact.get(0).Opportunities__r;
            }
        listBoughtContact = [Select Id,(Select Id,Name,StageName,closeDate,CreatedById from Opportunities__r where Availability_Status__c= TRUE and StageName= 'bought') from contact where Id =: con.id];  
            if(listBoughtContact!=null && listBoughtContact.size()>0){
                listBoughtOpps=listBoughtContact.get(0).Opportunities__r;
            }
        }
       
        catch(exception e){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception Occured' +e )); 
        }
    
    }
    
   
        
    
}