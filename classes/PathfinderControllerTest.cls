@isTest
public with sharing class PathfinderControllerTest {
    
    @TestSetup
    static void makeData(){
        MockTestData.createAccountAddressNotFound();
        MockTestData.createAccountWithAddress();
        MockTestData.createAccountWithoutAddress();
    }

    @isTest
    static void retrieveAccountsWithoutAddress(){
        Test.startTest();
        List<Account> lstAcc = PathfinderController.getAccountsWithEmptyAddress();
        Test.stopTest();
        System.assertEquals(1, lstAcc.size());
    }

    @isTest
    static void getLastUpdatedAccounts(){
        Test.startTest();
        List<Account> lstAcc = PathfinderController.getAccountsWithEmptyAddress();
        Test.stopTest();
        System.assertEquals(1, lstAcc.size());
    }

}
