public class InteractionExtension {

     private final Interaction__c interaction;
    public List<Interaction__c> listInteractions {get;set;}
    public List<Opportunity> listOpps {get;set;}
    public List<Interaction__c> listClosedInteractions {get;set;}
    public List<Opportunity> listClosedOpps {get;set;}
    public List<Interaction__c> listBoughtInteractions {get;set;}
    public List<Opportunity> listBoughtOpps {get;set;}
    
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public InteractionExtension(ApexPages.StandardController stdController) {
        this.interaction = (Interaction__c)stdController.getRecord();
         try{
         listInteractions = [Select Id,(Select Id,Name,StageName,closeDate,CreatedById from Opportunities__r where Availability_Status__c= TRUE and StageName NOT IN ('Bought','Lost')) from Interaction__c where Id=: interaction.id];
         listOpps =  listInteractions.get(0).Opportunities__r;
         listClosedInteractions = [Select Id,(Select Id,Name,StageName,closeDate,CreatedById from Opportunities__r where Availability_Status__c= false) from Interaction__c where Id=: interaction.id];
         if(listClosedInteractions!=null && listClosedInteractions.size()>0){
         		listClosedOpps =  listClosedInteractions.get(0).Opportunities__r;
         	}
         listBoughtInteractions = [Select Id,(Select Id,Name,StageName,closeDate,CreatedById from Opportunities__r where Availability_Status__c= TRUE and StageName= 'bought') from Interaction__c where Id=: interaction.id]; 
        
             if(listBoughtInteractions!=null && listBoughtInteractions.size()>0){
                 listBoughtOpps = listBoughtInteractions.get(0).Opportunities__r;
             }
			   
         }catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops some exception!'));
    }
    
 }
    
            
    
}