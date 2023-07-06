codeunit 50101 "Customer Order Post"
{
    TableNo = "Customer Order Header";

    var
        OpenPostedDocumentLbl: Label 'Open Posted Document?';

    trigger OnRun()
    begin
        InsertPostedCustomerOrderHeader(Rec);

        Rec.Delete();
    end;

    local procedure InsertPostedCustomerOrderHeader(var CustomerOrderHeader: Record "Customer Order Header")
    var
        PostedCustomerOrderHeader: Record "Posted Customer Order Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCopyCustomerOrderHeaderToPostedCustomerOrderHeader(CustomerOrderHeader, IsHandled);
        if IsHandled then
            exit;

        PostedCustomerOrderHeader.Init();
        PostedCustomerOrderHeader.TransferFields(CustomerOrderHeader);
        CustomerOrderHeader.CalcFields("Total Order Amount", "Total Paid Amount");
        PostedCustomerOrderHeader."Total Order Amount" := CustomerOrderHeader."Total Order Amount";
        PostedCustomerOrderHeader."Total Paid Amount" := CustomerOrderHeader."Total Paid Amount";
        PostedCustomerOrderHeader."No." := '';
        PostedCustomerOrderHeader.Insert(true);

        OnAfterInsertCustomerOrderHeaderToPostedCustomerOrderHeader(CustomerOrderHeader);

        InsertPostedCustomerOrderLine(CustomerOrderHeader, PostedCustomerOrderHeader);
        ChangeAssignedDocNoInPayments(CustomerOrderHeader, PostedCustomerOrderHeader."No.");
    end;

    local procedure InsertPostedCustomerOrderLine(CustomerOrderHeader: Record "Customer Order Header"; var PostedCustomerOrderHeader: Record "Posted Customer Order Header")
    var
        PostedCustomerOrderLine: Record "Posted Customer Order Line";
        CustomerOrderLine: Record "Customer Order Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCopyCustomerOrderLineToPostedCustomerOrderLine(CustomerOrderLine, IsHandled);
        if IsHandled then
            exit;

        CustomerOrderLine.SetRange("Document No.", CustomerOrderHeader."No.");
        if CustomerOrderLine.FindSet() then
            repeat
                PostedCustomerOrderLine.Init();
                PostedCustomerOrderLine.TransferFields(CustomerOrderLine);
                PostedCustomerOrderLine."Document No." := PostedCustomerOrderHeader."No.";
                PostedCustomerOrderLine.Insert(true);

                OnAfterInsertCustomerOrderLineToPostedCustomerOrderLine(CustomerOrderLine);
            until CustomerOrderLine.Next() = 0;

        if Confirm(OpenPostedDocumentLbl, true) then
            Page.Run(Page::"Posted Customer Order", PostedCustomerOrderHeader);
    end;

    local procedure ChangeAssignedDocNoInPayments(CustomerOrderHeader: Record "Customer Order Header"; PostDocNo: Code[20])
    var
        CustomerOrderPayment: Record "Customer Order Payment";
    begin
        CustomerOrderPayment.SetLoadFields("Assigned To Doc. No.");
        CustomerOrderPayment.SetRange("Assigned To Doc. No.", CustomerOrderHeader."No.");
        if CustomerOrderPayment.FindSet() then
            repeat
                CustomerOrderPayment."Assigned To Doc. No." := PostDocNo;
                CustomerOrderPayment.Modify();
            until CustomerOrderPayment.Next() = 0;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyCustomerOrderHeaderToPostedCustomerOrderHeader(var CustomerOrderHeader: Record "Customer Order Header"; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyCustomerOrderLineToPostedCustomerOrderLine(var CustomerOrderLine: Record "Customer Order Line"; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertCustomerOrderHeaderToPostedCustomerOrderHeader(var CustomerOrderHeader: Record "Customer Order Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertCustomerOrderLineToPostedCustomerOrderLine(var CustomerOrderLine: Record "Customer Order Line");
    begin
    end;
}
