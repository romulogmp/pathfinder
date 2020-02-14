@isTest
public with sharing class AccountsSelectorTest {
    
    @TestSetup
    static void makeData(){
        MockTestData.createAccountAddressNotFound();
        MockTestData.createAccountWithAddress();
        MockTestData.createAccountWithoutAddress();
    }

    @isTest
    static void retrieveAccountsWithoutAddress(){
        Test.startTest();
        List<Account> lstAcc = new AccountsSelector().selectAccountsWithEmptyAddress(1);
        Test.stopTest();
        System.assertEquals(1, lstAcc.size());
    }

    @isTest
    static void getLastUpdatedAccounts(){
        Test.startTest();
        List<Account> lstAcc = new AccountsSelector().selectLastUpdatedAccounts(1);
        Test.stopTest();
        System.assertEquals(1, lstAcc.size());
    }
}
