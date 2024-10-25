@IsTest
public with sharing class LeadTriggerHandlerTest {
@TestSetup
static void makeData(){
    
}    
    @IsTest
    public Static void test_HandleTitleNormalization() {
        List<Lead> leads = new List<Lead>();
        Lead l1 = new Lead(FirstName = 'Test',LastName = 'Lead1', Title = 'vp');
        Lead l2 = new Lead(FirstName = 'Test',LastName = 'Lead2', Title = 'management');
        Lead l3 = new Lead(FirstName = 'Test',LastName = 'Lead3', Title = 'jr');
        Lead l4 = new Lead(FirstName = 'Test',LastName = 'Lead4', Title = 'department head');

        Leads.add(l1);
        Leads.add(l2);
        Leads.add(l3);
        Leads.add(l4);
        Test.startTest();
        LeadTriggerHandler.handleTitleNormalization(leads);
        Test.stopTest();
        Assert.areEqual('Vice President', l1.Title,'Title does not match expected value');
        Assert.areEqual('Manager', l2.Title, 'Title does not match expected value');
        Assert.areEqual('Assistant', l3.Title, 'Title does not match expected value');
        Assert.areEqual('Executive', l4.Title, 'Title does not match expected value');

    }

    @IsTest
    public Static void test_handleAutoLeadScoring() {
        List<Lead> leads = new List<Lead>();
        Lead l1 = new Lead(FirstName = 'Test',LastName = 'Lead1', Email = 'test@test.com', Phone = '123456789', LeadSource = 'Website', Industry = 'Technology');
        Lead l2 = new Lead(FirstName = 'Test',LastName = 'Lead2', Email = 'testlead2@test.com', LeadSource = 'Website');
        Lead l3 = new Lead(FirstName = 'Test',LastName = 'Lead3', Phone = '234567890', Industry = 'Retail');
        Lead l4 = new Lead(FirstName = 'Test',LastName = 'Lead4');

        leads.add(l1);
        leads.add(l2);
        leads.add(l3);
        leads.add(l4);
        Test.startTest();
        LeadTriggerHandler.handleAutoLeadScoring(Leads);
        Test.stopTest();
        Assert.areEqual(18, l1.Lead_Score__c,'Lead Score does not match expected value');
        Assert.areEqual(3, l2.Lead_Score__c, 'Lead Score does not match expected value');
        Assert.areEqual(5, l3.Lead_Score__c, 'Lead Score does not match expected value');
        Assert.areEqual(0, l4.Lead_Score__c, 'Lead Score does not match expected value');

    }
    
    @IsTest
    public Static void test_handleLeadAutoConvert() {
        List<Lead> insertLeads = new List<Lead>();
        List<Lead> updateLeads = new List<Lead>();
        List<Contact> insertContacts = new List<Contact>();
        Lead l1 = new Lead(FirstName = 'Test',LastName = 'Lead1', Email = 'test1@test.com', Company = 'Test1');
        Lead l2 = new Lead(FirstName = 'Test',LastName = 'Lead2', Email = 'test22@test.com', Company = 'Test2');
        Lead l3 = new Lead(FirstName = 'Test',LastName = 'Lead3', Email = 'test3@test.com', Company = 'Test3');
        Lead l4 = new Lead(FirstName = 'Test',LastName = 'Lead4', Email = 'test4@test.com', Company = 'Test4');

        insertLeads.add(l1);
        insertLeads.add(l2);
        insertLeads.add(l3);
        insertLeads.add(l4);

        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con1 = new Contact(FirstName = 'Test',LastName = 'Lead1', Email = 'test1@test.com',AccountId = acc.Id);
        Contact con2 = new Contact(FirstName = 'Test',LastName = 'Lead2', Email = 'test2@test.com',AccountId = acc.Id);
        insertContacts.add(con1);
        insertContacts.add(con2);
        
        insert insertContacts;       
        insert insertLeads;
        l2.Email = 'test2@test.com';
        updateLeads.add(l1);
        updateLeads.add(l2);
        updateLeads.add(l3);
        updateLeads.add(l4);
        update updateLeads;


        Map<Id,Lead> convertedLeads = new Map<Id,Lead>([SELECT Id, IsConverted, ConvertedContactId FROM Lead WHERE IsConverted = true]);

        Assert.isTrue(convertedLeads.get(l1.Id).IsConverted,'lead is not converted');
        Assert.areEqual(convertedLeads.get(l1.Id).ConvertedContactId, con1.Id, 'Contact Id does not match expected Contact Id');
        Assert.isTrue(convertedLeads.get(l2.Id).IsConverted,'lead is not converted');
        Assert.areEqual(convertedLeads.get(l2.Id).ConvertedContactId, con2.Id, 'Contact Id does not match expected Contact Id');

        

    }
}