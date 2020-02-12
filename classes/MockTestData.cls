@isTest
public with sharing class MockTestData {
    
    public static void createAccountWithAddress(){
        insert new Account(Name = 'TestName',
                            BillingCity = 'TestCity',
                            BillingStreet = 'TestStreet',
                            BillingCountry = 'TestCountry',
                            Address_Not_Found__c = false);
    }

    public static void createAccountWithoutAddress(){
        insert new Account(Name = 'TestName',
                            Address_Not_Found__c = false);
    }

    public static void createAccountAddressNotFound(){
        insert new Account(Name = 'TestName',
                            Address_Not_Found__c = true);
    }
}