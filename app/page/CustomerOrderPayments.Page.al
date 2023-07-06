page 50106 "Customer Order Payments"
{
    ApplicationArea = All;
    Caption = 'Customer Order Payments';
    CardPageID = "Customer Order Payment";
    PageType = List;
    Editable = false;
    SourceTable = "Customer Order Payment";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Pay to Customer No."; Rec."Pay to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Pay to Customer No. field.';
                }
                field("Pay to Customer Name"; Rec."Pay to Customer Name")
                {
                    ToolTip = 'Specifies the value of the Pay to Customer Name field.';
                }
                field("Paid Amount"; Rec."Paid Amount")
                {
                    ToolTip = 'Specifies the value of the Paid Amount field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field(Assigned; Rec.Assigned)
                {
                    ToolTip = 'Specifies if the Payment Assigned.';
                }
                field("Assigned To Doc. No."; Rec."Assigned To Doc. No.")
                {
                    ToolTip = 'Specifies the Assigned To Doc. No.';

                    trigger OnDrillDown()
                    var
                        CustomerOrderHeader: Record "Customer Order Header";
                        PostedCustomerOrderHeader: Record "Posted Customer Order Header";
                    begin
                        if CustomerOrderHeader.Get(Rec."Assigned To Doc. No.") then
                            Page.RunModal(Page::"Customer Order Payments", CustomerOrderHeader)
                        else begin
                            PostedCustomerOrderHeader.Get(Rec."Assigned To Doc. No.");
                            Page.RunModal(Page::"Customer Order Payments", PostedCustomerOrderHeader);
                        end;
                    end;
                }
            }
        }
    }
}
