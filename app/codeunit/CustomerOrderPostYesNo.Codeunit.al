codeunit 50100 "Customer Order Post(Yes/No)"
{
    TableNo = "Customer Order Header";

    trigger OnRun()
    var
        TotalOrderAmountErr: Label 'Total Order Amount in Customer Order %1 must be greater than 0', Comment = '%1 = "No."';
    begin
        OnBeforeOnRun(Rec);

        Rec.CalcFields("Total Order Amount");
        if Rec."Total Order Amount" <= 0 then
            Error(TotalOrderAmountErr, Rec."No.");

        RunCustomerOrderPost(Rec);
    end;

    local procedure RunCustomerOrderPost(var CustomerOrderHeader: Record "Customer Order Header")
    var
        CustomerOrderPost: Codeunit "Customer Order Post";
        PostDocLbl: Label 'Are you sure you want to post the document?';
        HideDialog: Boolean;
        IsHandled: Boolean;
    begin
        OnBeforeConfirmSalesPost(CustomerOrderHeader, HideDialog, IsHandled);
        if IsHandled then
            exit;

        if not HideDialog then
            if not Confirm(PostDocLbl, true) then
                exit;

        CustomerOrderPost.Run(CustomerOrderHeader);

        OnAfterPost(CustomerOrderHeader);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRun(var CustomerOrderHeader: Record "Customer Order Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeConfirmSalesPost(var CustomerOrderHeader: Record "Customer Order Header"; var HideDialog: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPost(var CustomerOrderHeader: Record "Customer Order Header")
    begin
    end;
}
