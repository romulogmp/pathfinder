public with sharing class Accounts extends fflib_SObjectDomain {

    public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }
    
    public override void onApplyDefaults(){
        for(Account acc : (List <Account>) Records){
            acc.Description = 'Domain classes rock!';
        }
    }

    public override void onBeforeUpdate(Map<Id, SObject> oldMapAccount){

        updateAnnualRevenue(oldMapAccount);
    }

    private void updateAnnualRevenue(Map<Id, SObject> oldMapAccount){
        
        for(Account acc : (List<Account>)Records){
            Account oldValue = (Account)oldMapAccount.get(acc.Id);
            String oldDescription = oldValue.Description;
            acc.AnnualRevenue = acc.Description.getLevenshteinDistance(oldDescription);
        }
    }
}