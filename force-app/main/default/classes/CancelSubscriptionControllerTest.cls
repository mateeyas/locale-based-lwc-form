@isTest
public class CancelSubscriptionControllerTest {

    @isTest
    static void testCreateCase() {
        // Create test data
        String email = 'test@example.com';
        String bestellnummer = '123456';
        String kuendigungsdatum = 'At the end of my subscription term or renewal';
        String kuendigungsgrund = 'I found a better app';
        String sonstigerGrund = 'Test reason';

        // Call the method to test
        Test.startTest();
        Case createdCase = CancelSubscriptionController.createCase(
            email, bestellnummer, kuendigungsdatum, kuendigungsgrund, sonstigerGrund
        );
        Test.stopTest();

        // Query the case to include all required fields
        Case queriedCase = [SELECT Id, SuppliedEmail, RS_Order_Number__c, Desired_termination_date__c, 
                                   Reason_for_Termination__c, Other_Reason_for_Termination__c
                            FROM Case
                            WHERE Id = :createdCase.Id
                            LIMIT 1];

        // Assert the case was created successfully with the correct values
        System.assertNotEquals(queriedCase, null);
        System.assertEquals(queriedCase.SuppliedEmail, email);
        System.assertEquals(queriedCase.RS_Order_Number__c, bestellnummer);
        System.assertEquals(queriedCase.Desired_termination_date__c, kuendigungsdatum);
        System.assertEquals(queriedCase.Reason_for_Termination__c, kuendigungsgrund);
        System.assertEquals(queriedCase.Other_Reason_for_Termination__c, sonstigerGrund);
    }
}
