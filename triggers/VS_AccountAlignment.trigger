trigger VS_AccountAlignment on Account (after insert, after undelete, after update) {
	//ensuring this does not run if kicked off from a batch process
    If(!system.isBatch() && !system.isFuture()){
        
	List <String> acctIdList = new List <String> () ;
        for (Account acct : Trigger.new) {
            If(trigger.isinsert){
                acctIdList.add (acct.Id) ;
            }
            
            If(trigger.isupdate || trigger.isUndelete){
       //comparing the fields that are relevant to territory alignment 
       //to see if there was an update change. territory_vod__c should be included
       //the rest are customer specific territory filters
            
            string spec1 = trigger.oldmap.get(acct.id).specialty_1_vod__c;
            string spec2 = trigger.oldmap.get(acct.id).specialty_2_vod__c;
            
            boolean calloutbool = trigger.oldmap.get(acct.id).VS_terr_callout_trigger__c;
            
            string terrvod = trigger.oldmap.get(acct.id).territory_vod__c;
            If(acct.specialty_1_vod__c != spec1 ||
               acct.specialty_2_vod__c != spec2 ||
               (acct.VS_terr_callout_trigger__c != calloutbool && acct.VS_terr_callout_trigger__c == false)){
                   acctIdList.add(acct.id);
               }
            }
                
            
        }

System.debug ('hk: acctIdList is ' + acctIdList) ;

        // For all found Accounts, check the Territory_vod__c field
        String acctIds = '' ;
        /* for (Account a : [select Id, Territory_vod__c from Account where Id in :acctIdList and (Territory_vod__c = '' or Territory_vod__c = null)]) {
            if (acctIds != '') {
                acctIds += ',' ;
            }
            acctIds += a.Id ;   
        } */
        for (String acId : acctIdList) {
            if (acctIds != '') {
                acctIds += ',' ;
            }
            acctIds += acId ;   
        }

System.debug ('hk: acctIds is ' + acctIds) ;
        
        // Call the future method which does the aligment for all found accounts
        if (acctIds != '' && !System.isFuture()) {
            VS_AccountAlignmentCallout.calloutAssignTerritories(userinfo.getsessionid(), acctIds) ;
        }
    }

}