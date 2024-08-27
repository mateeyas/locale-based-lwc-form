# Locale-Based LWC Form

This repository contains a Lightning Web Component (LWC) built for a Salesforce Digital Experience site. The component is a form that creates cases for subscription cancellation requests, with form fields displayed based on the locale.

## Description

The Locale-Based LWC Form allows users to submit a subscription cancellation request through a form that is conditionally displayed based on the `locale` URL parameter. The form includes fields like email address, order number, desired termination date, and reason for termination, and it automatically creates a case in Salesforce with predefined values such as record type, status, and origin.

## Getting Started

### Dependencies

To run this project and deploy it to your Salesforce org, you will need:

- **Salesforce CLI**: Ensure you have the latest version of the Salesforce CLI installed.
- **Node.js**: Required if you are using Node.js dependencies or testing tools.

### Installing Salesforce CLI

1. Install Salesforce CLI:
   - [Salesforce CLI Download](https://developer.salesforce.com/tools/sfdxcli)

2. Verify the installation:
   ```bash
   sfdx --version
   ```

### Cloning the Repo

First, clone the repository to your local machine:

```bash
git clone https://github.com/yourusername/locale-based-lwc-form.git
cd locale-based-lwc-form
```

### Authorizing a Salesforce Org

Before deploying, you need to authorize a Salesforce org (e.g., sandbox or production):

1. Authorize your **staging** sandbox:
   ```bash
   sfdx auth:web:login --setalias staging --instanceurl https://test.salesforce.com
   ```

2. Authorize your **production** org:
   ```bash
   sfdx auth:web:login --setalias production --instanceurl https://login.salesforce.com
   ```

### Deploying to Salesforce

After you've authorized your org, you can deploy the code to your Salesforce org.

#### 1. **To deploy to the staging sandbox**:

```bash
sfdx project deploy start --source-dir force-app --target-org staging
```

#### 2. **To deploy to the production org using Metadata API**:

When deploying to production, ensure that you convert the source format to metadata format, and only run the relevant test class for deployment:

1. **Convert the source format to metadata format**:

   ```bash
   sfdx force:source:convert --rootdir force-app --outputdir mdapi_output_dir
   ```

2. **Deploy the converted metadata to production and only run the required test class**:

   ```bash
   sfdx force:mdapi:deploy --deploydir mdapi_output_dir --targetusername production --testlevel RunSpecifiedTests --runtests CancelSubscriptionControllerTest
   ```

3. **Monitor the deployment**:

   You can monitor the status of your deployment using:

   ```bash
   sfdx force:mdapi:deploy:report --targetusername production
   ```

### Testing the Component

1. After deployment, navigate to your **Salesforce Digital Experience** site in **Experience Builder**.
2. Add the `cancelSubscriptionForm` component to a page by dragging it from the component list.
3. Publish the site and ensure the form appears when the URL contains the `language=de` parameter.

### Troubleshooting

If the deployment fails due to missing fields or incorrect configuration, ensure that:

- All required fields (e.g., `SuppliedEmail`, `RS_Order_Number__c`) exist on the **Case** object.
- The `RecordTypeId` provided in the Apex controller matches an existing record type on the **Case** object.

## Help

If you have any questions or issues, feel free to reach out to the project maintainer.

## Author

Matt R ([matt@tala.dev](mailto:matt@tala.dev))

## Version History

* 1.0
    * Initial release with form and case creation logic.
    * Includes locale-based rendering and required fields for case creation.

## License

This project is licensed under the MIT License.
