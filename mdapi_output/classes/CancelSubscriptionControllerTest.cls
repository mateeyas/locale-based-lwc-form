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
        Case result = CancelSubscriptionController.createCase(
            email, bestellnummer, kuendigungsdatum, kuendigungsgrund, sonstigerGrund
        );
        Test.stopTest();

        // Assert the case was created successfully
        System.assertNotEquals(result, null);
        System.assertEquals(result.SuppliedEmail, email);
        System.assertEquals(result.RS_Order_Number__c, bestellnummer);
        System.assertEquals(result.Desired_termination_date__c, kuendigungsdatum);
        System.assertEquals(result.Reason_for_Termination__c, kuendigungsgrund);
        System.assertEquals(result.Other_Reason_for_Termination__c, sonstigerGrund);
    }
}
