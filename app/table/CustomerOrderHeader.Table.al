table 50100 "Customer Order Header"
{
    Caption = 'Customer Order Header';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Customer Orders";
    LookupPageId = "Customer Orders";

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
                    NoSeriesMgt.TestManual(PurchSetup."Order Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                Customer.SetLoadFields(Name, Address);
                if Customer.get("Customer No.") then begin
                    Rec."Customer Name" := Customer.Name;
                    Rec.Address := Customer.Address;
                end;
            end;
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
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Customer Order Line".Amount where("Document No." = field("No.")));
        }
        field(7; "Total Paid Amount"; Decimal)
        {
            Caption = 'Total Paid Amount';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Customer Order Payment"."Paid Amount" where("Assigned To Doc. No." = field("No.")));
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
    begin
        GetPurchSetup();

        if Rec."No." = '' then begin
            PurchSetup.TestField("Order Nos.");
            NoSeriesMgt.InitSeries(PurchSetup."Order Nos.", xRec."No. Series", "Document Date", "No.", "No. Series");
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
