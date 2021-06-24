public with sharing  class Amount {
    
public static  Amount__c bank  = new Amount__c();    
    
    @AuraEnabled   
    public static string Add_Ammount(string Name){
        bank.Account_Title__c = Name;
        insert bank;
        return bank.id;
    }
}