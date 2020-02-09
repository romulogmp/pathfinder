@isTest
public with sharing class PathfinderPlaceRequestTest {

    @TestSetup
    static void makeData(){

        googleAPI__c config =  new googleAPI__c();
        config.Name = 'googleAPI';
        config.endpoint__c = 'endpointP';
        config.apiKey__c = 'testKey';
        insert config;
    }

    private class MockTest implements HttpCalloutMock {
        public Integer statusCode;
        String body;

        public MockTest(Integer statusCode) {
            this.statusCode = statusCode;
        }

        public HTTPResponse respond(HTTPRequest req) {

            if(statusCode == 200){
                body = '{"candidates": [{"formatted_address": "Mr.Treublaan 7, 1097 DP Amsterdam, Países Baixos"}],"status": "OK"}';
            } else {
                body = '{"candidates": [],"status": "INVALID_REQUEST"}';
            }

            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody(body);
            response.setStatusCode(statusCode);
            return response;
        }
    }

    @isTest
    static void findPlaceFromTextRequestTestCode200(){
        
        String accountName = 'new10';

        MockTest mock = new MockTest(200);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock); 
        PathfinderPlaceRequest.sendRequest(accountName);
        Test.stopTest();
    }

    @isTest
    static void findPlaceFromTextRequestTestCode404(){
        
        String accountName = 'new10';

        MockTest mock = new MockTest(404);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock); 
        PathfinderPlaceRequest.sendRequest(accountName);
        Test.stopTest();
    }

    @isTest
    static void findPlaceFromTextRequestTestNullParam(){
        
        String accountName = '';

        MockTest mock = new MockTest(404);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock); 
        PathfinderPlaceRequest.sendRequest(accountName);
        Test.stopTest();
    }

    private class MockGeocodingTest implements HttpCalloutMock {
        public Integer statusCode;
        String body;

        public MockGeocodingTest(Integer statusCode) {
            this.statusCode = statusCode;
        }

        public HTTPResponse respond(HTTPRequest req) {

            if(statusCode == 200){
                body = '{"candidates": [{"formatted_address": "Mr.Treublaan 7, 1097 DP Amsterdam, Países Baixos"}],"status": "OK"}';
            } else {
                body = '{"error_message": "Invalid request. Missing the \'address\', \'components\', \'latlng\' or \'place_id\' parameter.","results": [],"status": "INVALID_REQUEST"}';
            }

            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody(body);
            response.setStatusCode(statusCode);
            return response;
        }
    }

    @isTest
    static void geocodeApiRequestTestCode200(){
        
        String address = '{"formatted_address": "Mr.Treublaan 7, 1097 DP Amsterdam, Países Baixos"}';

        MockGeocodingTest mockGeocoding = new MockGeocodingTest(200);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mockGeocoding); 
        PathfinderPlaceRequest.sendRequestGeocoding(address);
        Test.stopTest();
    }

    @isTest
    static void geocodeApiRequestTestCode400(){
        
        String address = '{"formatted_address": "Mr.Treublaan 7, 1097 DP Amsterdam, Países Baixos"}';

        MockGeocodingTest mockGeocoding = new MockGeocodingTest(400);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mockGeocoding); 
        PathfinderPlaceRequest.sendRequestGeocoding(address);
        Test.stopTest();
    }

    @isTest
    static void geocodeApiRequestTestNullParam(){
        
        String address = '';

        MockGeocodingTest mockGeocoding = new MockGeocodingTest(400);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mockGeocoding); 
        PathfinderPlaceRequest.sendRequestGeocoding(address);
        Test.stopTest();
    }
}
