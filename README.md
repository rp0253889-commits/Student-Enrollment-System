# Student Enrollment & Course Management System (SECMS)

Salesforce DX starter implementation based on the supplied SECMS project document.

## Main objects
- Student__c
- Course__c
- Instructor__c
- Enrollment__c

The Enrollment object links Student, Course, and Instructor through lookup relationships.

## Included
- Custom objects and fields
- Enrollment validation rules
- Apex trigger for enrollment date and instructor assignment
- Apex service class for instructor assignment
- Apex test class
- Permission set
- Report metadata
- Deployment notes

## Salesforce configuration still required in Setup
Some Salesforce features are configuration metadata rather than normal Apex source:
- Approval Process: `Approval_Enrollment_Request`
- Lightning App
- Custom tabs
- Page layouts / record types
- Record-triggered Flow for follow-up tasks
- Email template / email alert
- Dashboard components
- Organization-Wide Defaults and profiles

These requirements follow the supplied project document.

## Deploy
1. Authenticate:
   `sf org login web --alias secms`
2. Deploy:
   `sf project deploy start --source-dir force-app --target-org secms`
3. Run tests:
   `sf apex run test --target-org secms --test-level RunLocalTests --wait 10`

Adjust the API version if your Salesforce org requires another version.
