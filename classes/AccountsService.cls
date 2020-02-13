public with sharing class AccountsService {

    public static String findAddressByAccountName(String accountName) {

        map<String, Object> mapJsonData = new map<String, Object>();
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
                mapJsonData = (map<String, Object>)JSON.deserializeUntyped(strResponse);
                strResponse = String.valueOf(mapJsonData.get('candidates'));
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
                        String city = data.long_name;
                        mapData.put('city', city);
                    } else if(data.types.contains('route')){
                        String street = data.long_name;
                        mapData.put('street', street);
                    } else if(data.types.contains('country')){
                        String country = data.long_name;
                        mapData.put('country', country);
                    }
                }
            }

            if(!mapData.isEmpty()) { return mapData; }

            else { return mapData; }

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
}