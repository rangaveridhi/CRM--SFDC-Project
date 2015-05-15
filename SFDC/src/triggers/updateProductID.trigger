trigger updateProductID on RemoteSessionData__c (before insert,before update) {
   
    set<string> productStyleNo = new set<string>();    
    if(trigger.isUpdate || trigger.isInsert ){
        
        for(RemoteSessionData__c rsd : trigger.new){
            	  productStyleNo.add(rsd.Product_Style_No__c);
            }
        
        Map<String,ID> mapProducts =new Map<String,ID>();        
        
        List<product2> addProductMap = [select id,Style_No__c from product2 where Style_No__c in: productStyleNo];
        
        for(product2 p :addProductMap){
			
            mapProducts.put(p.Style_No__c, p.id);
            
        }
        List<RemoteSessionData__c> updateRSDList = new List<RemoteSessionData__c>();
        
        for(RemoteSessionData__c rsd : trigger.new){
			//RemoteSessionData__c r = rsd;
            rsd.Product__c= mapProducts.get(rsd.Product_Style_No__c);          
            
        }
        
        update updateRSDList;
        
        
        
    }
    
    
}