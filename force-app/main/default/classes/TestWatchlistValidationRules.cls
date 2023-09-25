@isTest
public class TestWatchlistValidationRules {

    @TestSetup
    static void setupTestData() {
        // Create a Watchlist record with valid data
        Watchlist__c validWatchlist = new Watchlist__c(
            Name = 'Valid Watchlist',
            Ticker__c='ABC',
            Current_Price__c = 100, // Valid value
            Stock_Available__c = 50   // Valid value
        );
        insert validWatchlist;
    }

    @IsTest
    static void testValidationRule1() {
        // Create a Watchlist record with Current_Price__c less than 0 (violating the 1st validation rule)
        Watchlist__c invalidWatchlist = new Watchlist__c(
            Name = 'Invalid Watchlist 1',
            Ticker__c='ABC',
            Current_Price__c = -10, // Invalid value
            Stock_Available__c = 50   // Valid value
        );

        // Attempt to insert the invalid record
        // This should trigger the validation rule 1
        // The expected error message is 'Cannot be Less than 0'
        Test.startTest();
        try {
            insert invalidWatchlist;
            System.assert(false, 'Validation rule 1 did not fire as expected.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Cannot be Less then 0'));
        }
        Test.stopTest();
    }

    @IsTest
    static void testValidationRule2() {
        // Create a Watchlist record with Stock_Available__c less than 0 (violating the 2nd validation rule)
        Watchlist__c invalidWatchlist = new Watchlist__c(
            Name = 'Invalid Watchlist 2',
            Ticker__c='ABC',
            Current_Price__c = 100, // Valid value
            Stock_Available__c = -5   // Invalid value
        );

        // Attempt to insert the invalid record
        // This should trigger the validation rule 2
        // The expected error message is 'Cannot be Less than 0'
        Test.startTest();
        try {
            insert invalidWatchlist;
            System.assert(false, 'Validation rule 2 did not fire as expected.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Cannot be less then 0'));
        }
        Test.stopTest();
    }
}