page 50108 "Customer Order Payments FB"
{
    ApplicationArea = All;
    Caption = 'Customer Order Payments';
    PageType = CardPart;
    SourceTable = "Customer Order Payment";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';

                    trigger OnDrillDown()
                    var
                        CustomerOrderPayment: Record "Customer Order Payment";
                    begin
                        CustomerOrderPayment := Rec;
                        CustomerOrderPayment.SetRecFilter();
                        Page.RunModal(Page::"Customer Order Payments", CustomerOrderPayment);
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Paid Amount"; Rec."Paid Amount")
                {
                    ToolTip = 'Specifies the value of the Paid Amount field.';
                }
            }
        }
    }
}
