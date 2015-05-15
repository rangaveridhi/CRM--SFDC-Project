<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Aniversary Email</fullName>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <template>unfiled$public/Contact_Send_Anniversary_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Birthday Email</fullName>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <template>unfiled$public/Contact_Birthday_Tomorrow_Birthday_Wishes</template>
    </alerts>
    <alerts>
        <fullName>Birthday Reminder Email</fullName>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <template>unfiled$public/Contact_Birthday_Tomorrow_Birthday_Wishes</template>
    </alerts>
    <alerts>
        <fullName>test</fullName>
        <protected>false</protected>
        <recipients>
            <recipient>tempuser1@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <template>unfiled$public/Contact_Birthday_Tomorrow_Birthday_Wishes</template>
    </alerts>
    <fieldUpdates>
        <fullName>Check Reset Anniversary Email System Box</fullName>
        <field>Reset_Aniversary_Email__c</field>
        <literalValue>1</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check Reset Birthday Email System Box</fullName>
        <field>Reset_Birthday_Email_System__c</field>
        <literalValue>1</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset Anniversary Birthday</fullName>
        <field>Next_Anniversary_Date1__c</field>
        <formula>IF ( MONTH (Anniversary__c)=2 &amp;&amp; DAY (Anniversary__c)=29,
IF ((DATE (YEAR(TODAY()),1,1) + 59) &gt; TODAY(),
(DATE (YEAR(TODAY()),1,1)) + 59,
(DATE (YEAR(TODAY())+1,1,1)) + 59),
IF (DATE (YEAR(TODAY()),MONTH(Anniversary__c),DAY(Anniversary__c)) &gt; TODAY(),
DATE (YEAR(TODAY()),MONTH(Anniversary__c),DAY(Anniversary__c)),
DATE (YEAR(TODAY())+1,MONTH(Anniversary__c),DAY(Anniversary__c))
)
)</formula>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset Anniversary System</fullName>
        <field>Reset_Aniversary_Email__c</field>
        <literalValue>0</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset Birthday System</fullName>
        <field>Reset_Birthday_Email_System__c</field>
        <literalValue>0</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset Next Birthday</fullName>
        <field>Reset_Next_Birthday__c</field>
        <formula>IF ( MONTH ( Birthday_New__c )=2 &amp;&amp; DAY (Birthday_New__c)=29, 
IF ((DATE (YEAR(TODAY()),1,1) + 59) &gt; TODAY(), 
(DATE (YEAR(TODAY()),1,1)) + 59, 
(DATE (YEAR(TODAY())+1,1,1)) + 59), 
IF (DATE (YEAR(TODAY()),MONTH(Birthday_New__c),DAY(Birthday_New__c)) &gt; TODAY(), 
DATE (YEAR(TODAY()),MONTH(Birthday_New__c),DAY(Birthday_New__c)), 
DATE (YEAR(TODAY())+1,MONTH(Birthday_New__c),DAY(Birthday_New__c)) 
) 
)</formula>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Reset Anniversary Email</fullName>
        <actions>
            <name>Reset Anniversary Birthday</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Reset_Aniversary_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Reset Birthday Email</fullName>
        <actions>
            <name>Reset Next Birthday</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Reset_Birthday_Email_System__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send_Anniversary_Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Reset_Aniversary_Email__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Anniversary__c</field>
            <operation>notEqual</operation>
            <value>1/1/1900</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send_Birthday_Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Reset_Birthday_Email_System__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Birthday_New__c</field>
            <operation>notEqual</operation>
            <value>1/1/1900</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>test</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Birthday Notification</fullName>
        <assignedTo>abdul.khan@in.ey.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>-7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Contact.Birthdate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
    </tasks>
</Workflow>
