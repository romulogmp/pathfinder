public with sharing class AccountsSelector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Account.Id,
            Account.Name,
            Account.BillingCity,
            Account.BillingStreet,
            Account.BillingCountry,
            Account.Address_Not_Found__c,
            Account.Phone };
    }

    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }

    public List<Account> selectAccountsWithEmptyAddress(Integer recordLimit) {   
        return (List<Account>) Database.query(
            newQueryFactory().
            setCondition('Address_Not_Found__c = false '+
            'AND (BillingCity = null ' +
            'OR BillingStreet = null ' +
            'OR BillingCountry = null)').
            setLimit(recordLimit).
            toSOQL());
    }
    
    public List<Account> selectLastUpdatedAccounts(Integer recordLimit) {
        
        return (List<Account>) Database.query(
            newQueryFactory().
            setOrdering('LastModifiedDate', 
                        fflib_QueryFactory.SortOrder.DESCENDING, 
                        true).
            setCondition('BillingCity != null ' +
            'AND BillingStreet != null ' +
            'AND BillingCountry != null').
            setLimit(recordLimit).
            toSOQL());
    }
}