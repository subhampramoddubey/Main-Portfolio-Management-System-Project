@isTest
public class PreventDuplicateApprovalHandlerClassTest {
    @isTest
    static void testHandlePreventDuplicateApproval() {
      
        // Create test Place_Orders__c records
        Place_Orders__c order1 = new Place_Orders__c(
            TickerName__c = 'Test Order 1',
            Order_Path__c = 'Order Pending',
            Quantity__c = 10,
            Order_Type__c = 'BUY',
            Purchase_Date__c = System.today()
        );
        Place_Orders__c order2 = new Place_Orders__c(
            TickerName__c = 'Test Order 2',
            Order_Path__c = 'Order Approved',
            Quantity__c = 100,
            Order_Type__c = 'BUY',
            Purchase_Date__c = System.today()
        );
        Place_Orders__c order3 = new Place_Orders__c(
            TickerName__c = 'Test Order 3',
            Order_Path__c = 'Order Rejected',
            Quantity__c = 1000,
            Order_Type__c = 'BUY',
            Purchase_Date__c = System.today()
        );
        insert new List<Place_Orders__c> { order1, order2, order3 };

        // Map of old Order Path values for the test orders
        Map<Id, Place_Orders__c> oldOrderMap = new Map<Id, Place_Orders__c>();
        oldOrderMap.put(order1.Id, order1);
        oldOrderMap.put(order2.Id, order2);
        oldOrderMap.put(order3.Id, order3);

        Test.startTest();

        // Call the handler method
        PreventDuplicateApprovalHandlerClass.handlePreventDuplicateApproval(new List<Place_Orders__c> { order1, order2, order3 }, oldOrderMap);

        Test.stopTest();

        // Assert the handler's behavior
        // Check that order1 was not changed (no errors added)
        System.assertEquals(0, order1.Order_Path__c.length());

        // Check that order2 and order3 have errors added
        System.assertEquals('You cannot submit an order for approval when it is already approved.', order2.Order_Path__c);
        System.assertEquals('You cannot submit an order for approval when it is already rejected.', order3.Order_Path__c);
    }
}