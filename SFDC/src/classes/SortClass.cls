public class SortClass {   
       public List<AggregateResult> listSessionProfiles{get;set;} 
        
        public SortClass(){
               listSessionProfiles= [Select Id,SessionID__c,Customer_Name__c,Sales_User_s_Name__c,Interaction_Name__c from RemoteSessionData__c where Ipad_UserName__c='eynmjfs@gmail.com' and isDeleted__c != true  group by Id,SessionID__c,Customer_Name__c,Sales_User_s_Name__c,Interaction_Name__c];
            
        }
 public void sortList(List<RemoteSessionData__c> listSessionProfiles, String order){

 
       List<RemoteSessionData__c> resultList = new List<RemoteSessionData__c>();
   
        //Create a map that can be used for sorting 
       Map<object, List<RemoteSessionData__c>> objectMap = new Map<object, List<RemoteSessionData__c>>();
       
       for(RemoteSessionData__c ob : listSessionProfiles){
                if(objectMap.get(ob.get(RemoteSessionData__c.createddate)) == null){  // For non Sobject use obj.ProperyName
                    objectMap.put(ob.get(RemoteSessionData__c.createddate), new List<RemoteSessionData__c>()); 
                }
                objectMap.get(ob.get(RemoteSessionData__c.createddate)).add(ob);
        }       
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
       
        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }
       
        //Apply the sorted values to the source list
        listSessionProfiles.clear();
        if(order.toLowerCase() == 'asc'){
            for(RemoteSessionData__c ob : resultList){
                listSessionProfiles.add(ob); 
            }
        }else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                listSessionProfiles.add(resultList[i]);  
            }
        }
    
 System.debug('descending order list-------------'+listSessionProfiles);
 }
    }