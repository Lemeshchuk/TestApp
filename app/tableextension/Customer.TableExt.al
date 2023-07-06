tableextension 50100 Customer extends Customer
{
    fields
    {
        field(50100; "Customer Orders Total"; Decimal)
        {
            Caption = 'Total Orders Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Posted Customer Order Header"."Total Order Amount" where("Customer No." = FIELD("No.")));
        }

        field(50101; "Customer Paid Amounts"; Decimal)
        {
            Caption = 'Total Paid Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Posted Customer Order Header"."Total Paid Amount" where("Customer No." = FIELD("No.")));
        }
    }
    var
        ConfirmDeleteLbl: Label 'Are you sure you want to delete this customer?';


    trigger OnBeforeDelete()
    var
        CustomerOrderHeader: Record "Customer Order Header";
    begin
        if CustomerOrderHeader.Get(Rec."No.") then
            if not Confirm(ConfirmDeleteLbl, false) then
                Error('');
    end;
}
