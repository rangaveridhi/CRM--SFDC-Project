public class RelationExtension {
    private final Relation__c relation;
    
    private ApexPages.StandardController stdController ;

    public relationExtension(ApexPages.StandardController stdController) {
       // this.relation.Parent_contact__C=Parent_Contact__r.Account.Contact__C;
        this.relation = (Relation__c)stdController.getRecord();
        Contact con = [select Account.Contact__c from contact where Id=:relation.Parent_contact__c];
        if(con!=null && con.Account.Contact__c!=null){
        relation.Parent_contact__c=con.Account.Contact__c;
        }
        this.stdController = stdController ;
    }
    
/** 
  * Custom Save overriding standard Controller's save.
**/
    public PageReference save() {
    //The page where the control should return after save.        
        PageReference pr = new PageReference('/'+relation.Parent_Contact__c);
        
    //To avoid duplicate relation entry, check if an existing Contact has been a relationship for the same parent Contact.        
        List<Relation__c> listRelation = [SELECT Id from Relation__c where Related_Contact__c = :relation.Related_Contact__c and Parent_Contact__c = :relation.Parent_Contact__c];
        
        if (listRelation.size() == 0){
            try{
              //  relation.Parent_contact__C=Parent_Contact__r.Account.Contact__C;
                stdController.save();
                return pr;
            }catch(Exception e){
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Unable to create the Relation.    '+e.getMessage() );
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        else{
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'A Relation with the same Profile already exists.');
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
public PageReference Cancel(){
 PageReference pr = stdController.cancel();
    return pr;

}    

}