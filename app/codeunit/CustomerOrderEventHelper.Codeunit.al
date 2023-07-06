codeunit 50102 "Customer Order Event Helper"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', true, true)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean)
    var
        PostedCustomerOrderHeader: Record "Posted Customer Order Header";
        ConfirmDeleteLbl: Label 'Are you sure you want to delete this customer?';
    begin
        PostedCustomerOrderHeader.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
        if not PostedCustomerOrderHeader.IsEmpty then
            if not Confirm(ConfirmDeleteLbl, false) then
                Error('');
    end;
}
