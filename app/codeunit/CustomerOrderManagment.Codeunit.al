codeunit 50103 "Customer Order Managment"
{
    internal procedure RunAndAssignPayment(var CustomerOrderHeader: Record "Customer Order Header")
    var
        CustomerOrderPayment: Record "Customer Order Payment";
        CustomerOrderPayments: Page "Customer Order Payments";
        PaidAmountMoreThenOrderAmountErr: Label 'Payment amount cant be more then Order Amount';
    begin
        CustomerOrderPayment.SetRange("Pay to Customer No.", CustomerOrderHeader."Customer No.");
        CustomerOrderPayment.SetRange(Assigned, false);
        CustomerOrderPayments.SetTableView(CustomerOrderPayment);
        CustomerOrderPayments.LookupMode := true;

        if CustomerOrderPayments.RunModal() = Action::LookupOK then
            CustomerOrderPayments.SetSelectionFilter(CustomerOrderPayment);

        if CustomerOrderPayment.FindSet() then begin
            CustomerOrderPayment.CalcSums("Paid Amount");
            if CustomerOrderPayment."Paid Amount" > (CustomerOrderHeader."Total Order Amount" - CustomerOrderHeader."Total Paid Amount") then
                Error(PaidAmountMoreThenOrderAmountErr)
            else
                repeat
                    CustomerOrderPayment.Assigned := true;
                    CustomerOrderPayment."Assigned To Doc. No." := CustomerOrderHeader."No.";
                    CustomerOrderPayment.Modify();
                until CustomerOrderPayment.Next() = 0;
        end;
    end;
}
