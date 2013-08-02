<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Territory_callout_update_Acc_trigger</fullName>
        <description>Update Account trigger to true</description>
        <field>VS_terr_callout_trigger__c</field>
        <literalValue>1</literalValue>
        <name>Territory callout - update Acc trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account_vod__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Territory Callout - set trigger flag</fullName>
        <actions>
            <name>Territory_callout_update_Acc_trigger</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(
ISNEW(),
Brick_vod__c &lt;&gt; PRIORVALUE(Brick_vod__c)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
