page 50105 SubscriptionListPage
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = SubscriptionTab;
    Caption = 'Subscription List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer Tenant ID"; Rec."Customer Tenant ID")
                {
                    ApplicationArea = All;
                }
                field("Customer Tenant Guid"; Rec."Customer Tenant Guid")
                {
                    ApplicationArea = All;
                }
                field(Appid; Rec.Appid)
                {
                    ApplicationArea = All;
                }
                field("App Name"; Rec."App Name")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Record Date"; Rec."Record Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }



    actions
    {
        area(processing)
        {
            action(MyAction)
            {
                Caption = 'My Action';
                Image = Action;
                ApplicationArea = All;
                trigger OnAction()
                var
                    InsertSubscription: Codeunit SubScriptionMgt;
                begin
                    // Add action logic here
                    InsertSubscription.Run();
                end;
            }
            action(Insert)
            {
                Caption = 'Insert';
                Image = Action;
                ApplicationArea = All;
                trigger OnAction()
                var
                    InsertSubscription: Codeunit SubScriptionMgt;
                begin
                    // Add action logic here
                    InsertSubscription.HttpRequestPOSTWithBasicAuth();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        InsertSubscription.HttpRequestPOSTWithBasicAuth();
    end;

    var
        InsertSubscription: Codeunit SubScriptionMgt;
}