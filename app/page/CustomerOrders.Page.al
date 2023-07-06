page 50102 "Customer Orders"
{
    ApplicationArea = All;
    Caption = 'Customer Orders';
    CardPageID = "Customer Order";
    Editable = false;
    PageType = List;
    SourceTable = "Customer Order Header";
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
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the document date. Filled in by default with the date the document was created.';
                }
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
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Post';
                actionref(Post_Promoted; Post)
                {
                }
            }
        }
    }
}