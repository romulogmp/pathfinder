public with sharing class AccountsService {

    public static String findAddressByAccountName(String accountName) {
        Candidates candidatesResult;
        String strResponse = '';
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        if(String.isBlank(accountName)){ return ''; }

        accountName = accountName.replace(' ', '%20');

        googleAPI__c confP = googleAPI__c.getValues('googleAPI');

        request.setEndpoint(confP.endpoint__c+'place/findplacefromtext/json?input='+accountName+'&inputtype=textquery&fields=formatted_address&key='+confP.apiKey__c);
        request.setMethod('GET');
        request.setHeader('content-type', 'application/json');
        request.setTimeout(12000);
        try{
            HttpResponse response = new HttpResponse();
            response = http.send(request);

            if (response.getStatusCode() == 200 ) {  
                strResponse = response.getBody();  
            } 

            if(!String.isBlank(strResponse)) {
                candidatesResult = (Candidates)JSON.deserialize(strResponse, Candidates.class);

                for(FormattedAddress candidate : candidatesResult.candidates){
                    strResponse = candidate.formatted_address;
                }
                
                return strResponse;
            } else { return ''; }
        } catch (Exception e) {
            System.debug('Error during Places API Callout: ' + e);
            return '';
        }
    }
    
    public static Map<String,String> findFullAddress(String address) {

        map<String, String> mapData = new map<String, String>{'city' =>'', 'street'=>'', 'country'=>''};
        Results dataResults;
        String strResponse = '';
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        if(String.isBlank(address)){ return mapData; }

        address = address.replace(' ', '%20');

        googleAPI__c confP = googleAPI__c.getValues('googleAPI');

        request.setEndpoint(confP.endpoint__c+'geocode/json?address='+address+'&key='+confP.apiKey__c);
        request.setMethod('GET');
        request.setHeader('content-type', 'application/json');
        request.setTimeout(12000);

        try{
            HttpResponse response = new HttpResponse();
            response = http.send(request);

            if (response.getStatusCode() == 200 ) {  
                strResponse = response.getBody();  
            }

            if(!String.isBlank(strResponse)) {
                dataResults = (Results)JSON.deserialize(strResponse, Results.class);
            }

            for(AddressComponent component :  dataResults.results){
                for(DataAddress data : component.address_components){
                    if(data.types.contains('locality')){
                        mapData.put('city', data.long_name);
                    } else if(data.types.contains('route')){
                        mapData.put('street', data.long_name);
                    } else if(data.types.contains('country')){
                        mapData.put('country', data.long_name);
                    }
                }
            }

            return mapData;

        } catch(Exception e) {
            System.debug('Error during Geocode API Callout: ' + e);
            return mapData;
        }
    }

    public class DataAddress{
        String long_name;
        String short_name;
        List<String> types;
    }

    public class AddressComponent{
        List<DataAddress> address_components;

    }
    public class Results{
        List<AddressComponent> results;

    }

    public class FormattedAddress{
        String formatted_address;
    }

    public class Candidates{
        List<FormattedAddress> candidates;
    }
}