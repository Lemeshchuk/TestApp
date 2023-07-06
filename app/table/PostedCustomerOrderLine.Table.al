table 50104 "Posted Customer Order Line"
{
    Caption = 'Posted Customer Order Line';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Posted Customer Order Subform";
    LookupPageId = "Posted Customer Order Subform";

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
            TableRelation = Item;
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[160])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
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
}
