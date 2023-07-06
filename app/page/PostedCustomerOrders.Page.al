page 50103 "Posted Customer Orders"
{
    ApplicationArea = All;
    Caption = 'Posted Customer Orders';
    CardPageID = "Posted Customer Order";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Customer Order Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the Customer No.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the Customer Name';
                }
                field("Total Order Amount"; Rec."Total Order Amount")
                {
                    ToolTip = 'Specifies the Total Order Amount';
                }
                field("Total Paid Amount"; Rec."Total Paid Amount")
                {
                    ToolTip = 'Specifies the Total Paid Amount';

                    trigger OnDrillDown()
                    var
                        CustomerOrderPayment: Record "Customer Order Payment";
                    begin
                        CustomerOrderPayment.SetRange("Assigned To Doc. No.", Rec."No.");
                        Page.RunModal(Page::"Customer Order Payments", CustomerOrderPayment);
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the document date. Filled in by default with the date the document was created.';
                }
            }
        }
    }
}
