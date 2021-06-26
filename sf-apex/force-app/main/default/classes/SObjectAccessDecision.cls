public with sharing class SObjectAccessDecision {
    
 
    //*************************************This method use to verify SobjectAccessDecisio
    private static List<Account> SobjectDecisionAccountInsert(){
        return new List<Account>
                                {
                                    new Account(name  = 'test',active__c = 'Yes'),
                                    new Account(name  = 'test2')
                                };
    }

    //************************ Strip fields that are not updatable**************************************** */
    public static void SObjectAccessDecisionDML(){
        List<Account> Accountlist = SobjectDecisionAccountInsert() ;
       // SObjectAccessDecision decision = Security.stripInaccessible(
                                                              //  AccessType.CREATABLE,
                                                              //  Accountlist);
      
    } 

}
