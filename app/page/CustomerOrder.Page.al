page 50100 "Customer Order"
{
    ApplicationArea = All;
    Caption = 'Customer Order';
    PageType = Card;
    SourceTable = "Customer Order Header";

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
                        Editable = false;
                    }
                    field("Total Paid Amount"; Rec."Total Paid Amount")
                    {
                        ToolTip = 'Specifies the Total Paid Amount';
                        Editable = false;
                    }
                }
            }
            part(CustomerOrderLines; "Customer Order Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }

        }
        area(FactBoxes)
        {
            part("Customer Order Payments FB"; "Customer Order Payments FB")
            {
                SubPageLink = "Assigned To Doc. No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Caption = 'Post';
                ToolTip = 'Specifies Sales VAT Invoice List, for selected customer in specific period';
                Image = Post;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CustomerOrderHeader: Record "Customer Order Header";
                    CustomerOrderPostYesNo: Codeunit "Customer Order Post(Yes/No)";
                begin
                    CustomerOrderHeader := Rec;
                    CustomerOrderHeader.SetRecFilter();
                    CustomerOrderPostYesNo.Run(CustomerOrderHeader);
                end;
            }

            action("Set payment")
            {
                Caption = 'Set payment';
                ToolTip = 'Specifies Sales VAT Invoice List, for selected customer in specific period';
                Image = PaymentJournal;
                ApplicationArea = All;
                Enabled = Rec."Total Paid Amount" < Rec."Total Order Amount";

                trigger OnAction()
                var
                    CustomerOrderManagment: Codeunit "Customer Order Managment";
                begin
                    CustomerOrderManagment.RunAndAssignPayment(Rec);
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Post';
                actionref(Post_Promoted; Post)
                {
                }
                actionref("Set payment_Promoted"; "Set payment")
                {
                }
            }
        }
    }
}