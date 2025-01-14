page 50106 SubscriptionAPIPage
{
    PageType = API;
    ApplicationArea = All;
    SourceTable = SubscriptionTab;
    Caption = 'Subscription API';
    APIPublisher = 'nwth';
    APIGroup = 'nwth';
    APIVersion = 'v2.0';
    EntityName = 'nwthsubscription';
    EntitySetName = 'nwthsubscriptions';
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(customertenantid; Rec."Customer Tenant ID")
                {
                    ApplicationArea = All;
                }
                field(customertenantguid; Rec."Customer Tenant Guid")
                {
                    ApplicationArea = All;
                }
                field(appid; Rec.Appid)
                {
                    ApplicationArea = All;
                }
                field(appname; Rec."App Name")
                {
                    ApplicationArea = All;
                }
                field(customername; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field(recorddate; Rec."Record Date")
                {
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // Define actions if needed
    }
}