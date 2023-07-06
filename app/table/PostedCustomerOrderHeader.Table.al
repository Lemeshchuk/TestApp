table 50103 "Posted Customer Order Header"
{
    Caption = 'Posted Customer Order Header';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Posted Customer Orders";
    LookupPageId = "Posted Customer Orders";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = ToBeClassified;
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(6; "Total Order Amount"; Decimal)
        {
            Caption = 'Total Order Amount';
            Editable = false;
        }
        field(7; "Total Paid Amount"; Decimal)
        {
            Caption = 'Total Paid Amount';
            Editable = false;
        }
        field(8; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(9; Address; Text[100])
        {
            Caption = 'Address';
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
    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        PurchSetup.Get();

        if Rec."No." = '' then begin
            PurchSetup.TestField("Posted Invoice Nos.");
            NoSeriesMgt.InitSeries(PurchSetup."Posted Invoice Nos.", xRec."No. Series", "Document Date", "No.", "No. Series");
        end;
    end;

}
