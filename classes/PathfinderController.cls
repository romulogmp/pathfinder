public with sharing class PathfinderController {
    
    @AuraEnabled(cacheable = true)
    public static List<Account> getAccountsWithEmptyAddress() {
        return [SELECT 
                        Id, 
                        Name, 
                        BillingCity, 
                        BillingStreet, 
                        BillingCountry,
                        Address_Not_Found__c,
                        Phone 
                FROM Account 
                WHERE Address_Not_Found__c = false
                AND (BillingCity = null 
                OR BillingStreet = null 
                OR BillingCountry = null)
                Limit 10];
    }

    @AuraEnabled(cacheable = true)
    public static List<Account> getLastUpdatedAccounts() {
        return [SELECT 
                        Id, 
                        Name, 
                        BillingCity, 
                        BillingStreet, 
                        BillingCountry, 
                        Phone 
                FROM Account
                WHERE BillingCity != null 
                AND BillingStreet != null 
                AND BillingCountry != null
                ORDER BY LastModifiedDate DESC
                Limit 30];
    }
}
