import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import createCase from '@salesforce/apex/CancelSubscriptionController.createCase';

export default class CancelSubscriptionForm extends LightningElement {
    @track email = ''; // SuppliedEmail
    @track bestellnummer = ''; // RS_Order_Number__c
    @track kuendigungsdatum = ''; // Desired_termination_date__c
    @track kuendigungsgrund = ''; // Reason_for_Termination__c
    @track sonstigerGrund = ''; // Other_Reason_for_Termination__c
    @track showForm = false; // Show the form only if language is "de"
    @track showSonstigerGrund = false; // Show "Other reason" field conditionally
    @track isLoading = false; // Disable the button and show spinner on submit
    @track isSubmitted = false; // Show the success message
    @track caseNumber = ''; // Case number to display after submission

    // Dropdown options for desired termination date
    kuendigungsdatumOptions = [
      { label: 'Zum Ende der Laufzeit bzw. der Verlängerung', value: 'At the end of my subscription term or renewal' },
      { label: 'Zum frühestmöglichen Termin', value: 'As soon as possible' }
    ];

    // Dropdown options for reason for termination
    kuendigungsgrundOptions = [
      { label: 'Es gibt technische Probleme', value: 'There are technical problems' },
      { label: 'Ich nutze diesen Dienst zu selten', value: 'I rarely use this service' },
      { label: 'Ich habe eine bessere App gefunden', value: 'I found a better app' },
      { label: 'Ich kündige aus Kostengründen', value: 'I\'m resigning for cost reasons' },
      { label: 'Sonstiges', value: 'Miscellaneous' },
      { label: 'Keine Angabe', value: 'No information' }
    ];

    @wire(CurrentPageReference)
    pageRef;

    connectedCallback() {
        this.checkLanguage();
    }

    checkLanguage() {
        if (this.pageRef && this.pageRef.state && this.pageRef.state.language) {
            const language = this.pageRef.state.language;
            if (language === 'de') {
                this.showForm = true;
            }
        }
    }

    handleInputChange(event) {
        const field = event.target.dataset.id;
        if (field === 'email') {
            this.email = event.target.value;
        } else if (field === 'bestellnummer') {
            this.bestellnummer = event.target.value;
        } else if (field === 'kuendigungsdatum') {
            this.kuendigungsdatum = event.target.value;
        } else if (field === 'kuendigungsgrund') {
            this.kuendigungsgrund = event.target.value;
            // Show "Other reason" field if "Sonstiges" is selected
            this.showSonstigerGrund = (this.kuendigungsgrund === 'Miscellaneous');
        } else if (field === 'sonstigerGrund') {
            this.sonstigerGrund = event.target.value;
        }
    }

    handleSubmit() {
        // Validate required fields
        if (this.email && this.kuendigungsdatum && this.kuendigungsgrund) {
            // Disable the button and show a spinner
            this.isLoading = true;

            // Create a Case
            createCase({
                email: this.email,
                bestellnummer: this.bestellnummer,
                kuendigungsdatum: this.kuendigungsdatum,
                kuendigungsgrund: this.kuendigungsgrund,
                sonstigerGrund: this.sonstigerGrund
            })
                .then(result => {
                    // Display the success message and case number
                    this.caseNumber = result.CaseNumber;
                    this.isSubmitted = true;
                    this.isLoading = false;
                })
                .catch(error => {
                  console.error('Error creating case:', error);
                  alert('Ihre Anfrage konnte nicht gesendet werden: ' + (error.body.message || 'Ihre Anfrage konnte nicht gesendet werden.'));
                  this.isLoading = false;
                });
        } else {
            alert('Bitte füllen Sie alle erforderlichen Felder aus.');
        }
    }
}
