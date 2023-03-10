/**
 * Created by Yury Nistratau on 05.01.2023.
 */

@IsTest
private class ActionUpdateRatesTest {
    @TestSetup
    static void setup() {
        ActionSettings__c actionSettings = ActionSettings__c.getOrgDefaults();
        ActionUpdateRates actionUpdateRates = new ActionUpdateRates();
        actionSettings.Name = actionUpdateRates.getType().getName();
        actionSettings.Interval__c = 2;
        actionSettings.Attempts__c = 5;
        insert actionSettings;
    }

    @IsTest
    static void testUpdateRatesPositive() {
        HTTPMockFactory mock = new HTTPMockFactory(200, 'OK', 'Response', new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        ActionExecutor.execute(new ActionUpdateRates());
        Test.stopTest();
        System.assertEquals(0, [SELECT COUNT() FROM AsyncApexJob]);
    }

    @IsTest
    static void testUpdateRatesNegative() {
        HTTPMockFactory mock = new HTTPMockFactory(404, 'Not found', 'Error', new Map<String, String>());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        ActionUpdateRates actionUpdateRates = new ActionUpdateRates();
        ActionExecutor.execute(actionUpdateRates);
        Test.stopTest();
        ActionSettings__c actionSettings = ActionSettings__c.getOrgDefaults();
        System.assertEquals(5, actionSettings.Attempts__c);
        System.assertEquals(2, actionSettings.Interval__c);
    }

}