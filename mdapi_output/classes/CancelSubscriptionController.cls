// Created by Matt R 20240827

public with sharing class CancelSubscriptionController {
    @AuraEnabled
    public static Case createCase(
        String email, 
        String bestellnummer, 
        String kuendigungsdatum, 
        String kuendigungsgrund, 
        String sonstigerGrund
    ) {
        // Set the required fields for the new case
        Case newCase = new Case(
            RecordTypeId = '0126T000001pTVsQAM',
            Description = 'Subscription cancelation request from German support site web form',
            Origin = 'Web', 
            Status = 'New', 
            Subject = 'Cancel subscription',
            SuppliedEmail = email, 
            Desired_termination_date__c = kuendigungsdatum, 
            Reason_for_Termination__c = kuendigungsgrund
        );

        // Only set RS_Order_Number__c if bestellnummer is provided
        if (!String.isBlank(bestellnummer)) {
            newCase.RS_Order_Number__c = bestellnummer;
        }

        // Only add the Other_Reason_for_Termination__c field if sonstigerGrund is provided
        if (!String.isBlank(sonstigerGrund)) {
            newCase.Other_Reason_for_Termination__c = sonstigerGrund;
        }

        // Insert the case into Salesforce
        insert newCase;

        // Query the case to get the case number
        newCase = [SELECT Id, CaseNumber FROM Case WHERE Id = :newCase.Id LIMIT 1];
        return newCase;
    }
}
