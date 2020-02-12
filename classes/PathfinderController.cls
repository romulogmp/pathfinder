public with sharing class PathfinderController {
    
    @AuraEnabled(cacheable = true)
    public static List<Account> getAccountsWithEmptyAddress() {
        return new AccountsSelector().selectAccountsWithEmptyAddress(10);
    }

    @AuraEnabled(cacheable = true)
    public static List<Account> getLastUpdatedAccounts() {
        return new AccountsSelector().selectLastUpdatedAccounts(30);
    }
}