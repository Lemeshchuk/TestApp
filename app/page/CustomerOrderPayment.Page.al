page 50107 "Customer Order Payment"
{
    ApplicationArea = All;
    Caption = 'Customer Order Payment';
    PageType = Card;
    SourceTable = "Customer Order Payment";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Editable = false;
                }
                field("Pay to Customer No."; Rec."Pay to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Pay to Customer No. field.';
                    Editable = not Rec.Assigned;
                }
                field("Pay to Customer Name"; Rec."Pay to Customer Name")
                {
                    ToolTip = 'Specifies the value of the Pay to Customer Name field.';
                    Editable = not Rec.Assigned;
                }
                field("Paid Amount"; Rec."Paid Amount")
                {
                    ToolTip = 'Specifies the value of the Paid Amount field.';
                    Editable = not Rec.Assigned;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    Editable = not Rec.Assigned;
                }
                field(Assigned; Rec.Assigned)
                {
                    ToolTip = 'Specifies the value of the Assigned field.';
                    Editable = false;
                }
                field("Assigned To Doc. No."; Rec."Assigned To Doc. No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the Assigned To Doc. No.';
                }
            }
        }
    }
}
