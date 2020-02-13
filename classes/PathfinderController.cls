public with sharing class PathfinderController {
    
    @AuraEnabled(cacheable = true)
    public static List<Account> getAccountsWithEmptyAddress() {
        return new AccountsSelector().selectAccountsWithEmptyAddress(10);
    }

    @AuraEnabled(cacheable = true)
    public static List<Account> getLastUpdatedAccounts() {
        return new AccountsSelector().selectLastUpdatedAccounts(30);
    }

    @AuraEnabled
    public static String findAddressByAccountName(String accountName) {
        return AccountsService.findAddressByAccountName(accountName);
    }

    @AuraEnabled
    public static Map<String, String> findFullAddress(String address) {
        return AccountsService.findFullAddress(address);
    }
}