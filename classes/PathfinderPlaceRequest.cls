public with sharing class PathfinderPlaceRequest {

    @AuraEnabled
    public static String sendRequest(String accountName) {

        map<String, Object> mapJsonData = new map<String, Object>();
        String strResponse = '';
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        if(String.isBlank(accountName)){ return null; }

        accountName = accountName.replace(' ', '%20');

        googleAPI__c confP = googleAPI__c.getValues('googleAPI');

        request.setEndpoint(confP.endpoint__c+'place/findplacefromtext/json?input='+accountName+'&inputtype=textquery&fields=formatted_address&key='+confP.apiKey__c);
        request.setMethod('GET');
        request.setHeader('content-type', 'application/json');
        request.setTimeout(12000);

        HttpResponse response = new HttpResponse();
        response = http.send(request);

        if (response.getStatusCode() == 200 ) {  
            strResponse = response.getBody();  
        } 

        if(!String.isBlank(strResponse)) {
            mapJsonData = (map<String, Object>)JSON.deserializeUntyped(strResponse);
            strResponse = String.valueOf(mapJsonData.get('candidates'));
            return strResponse;
        } else { return null; }

    }

    @AuraEnabled
    public static map<String, Object> sendRequestGeocoding(String address) {

        map<String, Object> mapJsonData = new map<String, Object>();
        String strResponse = '';
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        if(String.isBlank(address)){ return null; }

        address = address.replace(' ', '%20');

        googleAPI__c confP = googleAPI__c.getValues('googleAPI');

        request.setEndpoint(confP.endpoint__c+'geocode/json?address='+address+'&key='+confP.apiKey__c);
        request.setMethod('GET');
        request.setHeader('content-type', 'application/json');
        request.setTimeout(12000);

        HttpResponse response = new HttpResponse();
        response = http.send(request);

        if (response.getStatusCode() == 200 ) {  
            strResponse = response.getBody();  
        } 

        if(!String.isBlank(strResponse)) {
            mapJsonData = (map<String, Object>)JSON.deserializeUntyped(strResponse);
        }

        if(!mapJsonData.isEmpty()) { return mapJsonData; }
        else { return null; }

    }
}