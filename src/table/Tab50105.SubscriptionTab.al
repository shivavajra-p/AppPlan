table 50105 SubscriptionTab
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer Tenant ID"; Guid)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Customer Tenant Guid"; guid)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Appid; guid)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "App Name"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Customer Name"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Record Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        //add start date , end date , status
        field(7; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Status; Code[20])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Customer Tenant ID", "Customer Tenant Guid", Appid)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}