page 50105 "Posted Customer Order Subform"
{
    ApplicationArea = All;
    Caption = 'Lines';
    PageType = ListPart;
    Editable = false;
    SourceTable = "Posted Customer Order Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of an item';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the entry of the product to be imported.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the number of units of the item specified in the line.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the code for the location where the items on the line will be located.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the cost of one unit of the selected item, including discount and item costs.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the basis for calculating payments';
                }
            }
        }
    }
}
