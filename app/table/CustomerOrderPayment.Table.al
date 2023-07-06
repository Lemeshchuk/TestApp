table 50102 "Customer Order Payment"
{
    Caption = 'Customer Order Payment';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Customer Order Payments";
    LookupPageId = "Customer Order Payments";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                GetPurchSetup();
                if "No." <> xRec."No." then begin
                    NoSeriesMgt.TestManual(PurchSetup."Quote Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Pay to Customer No."; Code[20])
        {
            Caption = 'Pay to Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                Customer.SetLoadFields(Name);
                if Customer.get("Pay to Customer No.") then
                    Rec."Pay to Customer Name" := Customer.Name;
            end;
        }
        field(3; "Pay to Customer Name"; Text[100])
        {
            Caption = 'Pay to Customer Name';
            DataClassification = ToBeClassified;
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(5; "Paid Amount"; Decimal)
        {
            Caption = 'Paid Amount';
            DataClassification = ToBeClassified;
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(7; Assigned; Boolean)
        {
            Caption = 'Assigned';
            DataClassification = ToBeClassified;
        }
        field(8; "Assigned To Doc. No."; Code[20])
        {
            Caption = 'Assigned To Doc. No';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }

    }

    trigger OnInsert()
    begin
        GetPurchSetup();

        if Rec."No." = '' then begin
            PurchSetup.TestField("Quote Nos.");
            NoSeriesMgt.InitSeries(PurchSetup."Quote Nos.", xRec."No. Series", "Document Date", "No.", "No. Series");
        end;

        Rec."Document Date" := WorkDate();
    end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurchSetupRead: Boolean;


    local procedure GetPurchSetup()
    begin
        if not PurchSetupRead then
            PurchSetup.Get()
        else
            exit;

        PurchSetupRead := true;
    end;
}
