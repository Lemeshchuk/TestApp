page 50104 "Posted Customer Order"
{
    ApplicationArea = All;
    Caption = 'Posted Customer Order';
    PageType = Card;
    Editable = false;
    SourceTable = "Posted Customer Order Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

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
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the document date. Filled in by default with the date the document was created.';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies Address of the Customers.';
                }
                group(Amounts)
                {
                    Caption = 'Amounts';
                    field("Total Order Amount"; Rec."Total Order Amount")
                    {
                        ToolTip = 'Specifies the Total Order Amount';
                    }
                    field("Total Paid Amount"; Rec."Total Paid Amount")
                    {
                        ToolTip = 'Specifies the Total Paid Amount';
                        Editable = false;

                        trigger OnDrillDown()
                        var
                            CustomerOrderPayment: Record "Customer Order Payment";
                        begin
                            CustomerOrderPayment.SetRange("Assigned To Doc. No.", Rec."No.");
                            Page.RunModal(Page::"Customer Order Payments", CustomerOrderPayment);
                        end;
                    }
                }
            }
            part(CustomerOrderLines; "Posted Customer Order Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }
}
