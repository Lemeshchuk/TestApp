pageextension 50101 "Customer Card" extends "Customer Card"
{
    layout
    {
        addafter(General)
        {
            group("Customer Orders")
            {
                Caption = 'Customer Orders';

                field("Customer Orders Total"; Rec."Customer Orders Total")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer orders total amounts.';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        PostedCustomerOrderHeader: Record "Posted Customer Order Header";
                    begin
                        PostedCustomerOrderHeader.SetRange("Customer No.", Rec."No.");
                        Page.RunModal(Page::"Posted Customer Orders", PostedCustomerOrderHeader);
                    end;
                }
                field("Customer Orders Paid Amounts"; Rec."Customer Paid Amounts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer orders paid amounts.';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        CustomerOrderPayment: Record "Customer Order Payment";
                    begin
                        CustomerOrderPayment.SetRange("Pay to Customer No.", Rec."No.");
                        Page.RunModal(Page::"Customer Order Payments", CustomerOrderPayment);
                    end;
                }
            }
        }

        addfirst(factboxes)
        {
            part("Customer Order Payments FB"; "Customer Order Payments FB")
            {
                SubPageLink = "Pay To Customer No." = FIELD("No.");
            }
        }

        moveafter(City; "Combine Shipments")

        movebefore("Bill-to Customer No."; "Cash Flow Payment Terms Code")

        movefirst(Balance; CreditLimit, CalcCreditLimitLCYExpendedPct)

        modify("Address 2")
        {
            Caption = 'New Address 2';
        }
        modify("Allow Line Disc.")
        {
            Caption = 'New Allow Line Disc.';
        }
        modify("Combine Shipments")
        {
            Caption = 'New Combine Shipments';
        }
    }
}
