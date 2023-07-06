table 50101 "Customer Order Line"
{
    Caption = 'Customer Order Line';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Customer Order Subform";
    LookupPageId = "Customer Order Subform";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Customer Order Header"."No.";
            ValidateTableRelation = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
            TableRelation = Item;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if Rec."No." <> '' then begin
                    Item.SetLoadFields(Description);
                    Item.Get("No.");
                    Rec.Description := Item.Description;
                end;
            end;
        }
        field(4; Description; Text[160])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateAmounts();
            end;
        }
        field(7; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
            DataClassification = ToBeClassified;
        }
        field(8; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 2 : 5;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateAmounts();
            end;
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    local procedure UpdateAmounts()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();

        Validate(Rec.Amount, Round((Rec."Unit Price") * Rec.Quantity, GLSetup."Amount Rounding Precision", '='));
    end;
}
