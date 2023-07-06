codeunit 50109 "Customer Orders And Payments"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        LibraryRandom: Codeunit "Library - Random";
        LibraryWarehouse: Codeunit "Library - Warehouse";
        LibraryInventory: Codeunit "Library - Inventory";
        LibrarySales: Codeunit "Library - Sales";
        PostCustOrderErr: Label 'Total Order Amount in Customer Order %1 must be greater than 0', Comment = '%1 = "No."';
        PaidAmountMoreThenOrderAmountErr: Label 'Payment amount cant be more then Order Amount';
        CustOrderNoErr: Label 'Customer Order No. is different';
        CustOrderAmountErr: Label 'Customer Order Amount is different';
        CustOrderPaymentAssignedToDocNoErr: Label 'Assigned To Doc. No. is different';

    [Test]
    [HandlerFunctions('ConfirmTrue,PageHandlerPostedCustomerOrder')]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure CheckPostCustomerOrder()
    var
        CustomerOrderHeader: Record "Customer Order Header";
        PostedCustomerOrderHeader: Record "Posted Customer Order Header";
        CustomerOrderPage: TestPage "Customer Order";
    begin
        // [GIVEN]
        CreateCustomerOrder(CustomerOrderHeader);
        PostedCustomerOrderHeader.DeleteAll();

        // [WHEN]
        CustomerOrderPage.OpenEdit();
        CustomerOrderPage.GoToRecord(CustomerOrderHeader);
        CustomerOrderPage.Post.Invoke();

        // [THEN]
        PostedCustomerOrderHeader.FindFirst();
        Assert.IsTrue(PostedCustomerOrderHeader."No." <> '', CustOrderNoErr);
        Assert.IsTrue(PostedCustomerOrderHeader."Customer No." = CustomerOrderHeader."Customer No.", CustOrderNoErr);
    end;

    [Test]
    [HandlerFunctions('ModalPageHandlerCustomerOrderPayments')]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure CheckSetPaymentOnCustomerOrder()
    var
        CustomerOrderHeader: Record "Customer Order Header";
        CustomerOrderPayment: Record "Customer Order Payment";
        CustomerOrderPage: TestPage "Customer Order";
    begin
        // [GIVEN]
        CreateCustomerOrder(CustomerOrderHeader);
        CustomerOrderHeader.CalcFields("Total Order Amount");
        CreateCustomerPayment(CustomerOrderPayment, CustomerOrderHeader);

        // [WHEN]
        CustomerOrderPage.OpenEdit();
        CustomerOrderPage.GoToRecord(CustomerOrderHeader);
        CustomerOrderPage."Set payment".Invoke();

        // [THEN]
        CustomerOrderHeader.CalcFields("Total Paid Amount");
        Assert.IsTrue(CustomerOrderHeader."Total Paid Amount" = CustomerOrderPayment."Paid Amount", CustOrderAmountErr);
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure CheckErorrOnPostCustOrderWithZeroAmount()
    var
        CustomerOrderHeader: Record "Customer Order Header";
        CustomerOrderPage: TestPage "Customer Order";
        ExpectedErrorTxt: Text[100];
    begin
        // [GIVEN]
        CreateCustomerOrder(CustomerOrderHeader);
        ClearUnitPriceOnCustomerOrderLine(CustomerOrderHeader);
        ExpectedErrorTxt := STRSUBSTNO(PostCustOrderErr, CustomerOrderHeader."No.");

        // [WHEN]
        CustomerOrderPage.OpenEdit();
        CustomerOrderPage.GoToRecord(CustomerOrderHeader);

        // [THEN]
        asserterror CustomerOrderPage.Post.Invoke();
        Assert.ExpectedError(ExpectedErrorTxt);
    end;

    [Test]
    [HandlerFunctions('ConfirmTrue,ModalPageHandlerCustomerOrderPayments,PageHandlerPostedCustomerOrder')]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure CheckUpdatingAssignedDocNoOnPaymentAfterPostCustOrder()
    var
        CustomerOrderHeader: Record "Customer Order Header";
        PostedCustomerOrderHeader: Record "Posted Customer Order Header";
        CustomerOrderPayment: Record "Customer Order Payment";
        CustomerOrderPage: TestPage "Customer Order";
    begin
        // [GIVEN]
        CreateCustomerOrder(CustomerOrderHeader);
        CustomerOrderHeader.CalcFields("Total Order Amount");
        CreateCustomerPayment(CustomerOrderPayment, CustomerOrderHeader);
        PostedCustomerOrderHeader.DeleteAll();

        // [WHEN]
        CustomerOrderPage.OpenEdit();
        CustomerOrderPage.GoToRecord(CustomerOrderHeader);
        CustomerOrderPage."Set payment".Invoke();
        CustomerOrderPayment.Get(CustomerOrderPayment."No.");

        // [THEN]
        Assert.IsTrue(CustomerOrderPayment."Assigned To Doc. No." = CustomerOrderHeader."No.", CustOrderPaymentAssignedToDocNoErr);
        CustomerOrderPage.Post.Invoke();

        PostedCustomerOrderHeader.FindFirst();
        CustomerOrderPayment.Get(CustomerOrderPayment."No.");
        Assert.IsFalse(CustomerOrderPayment."Assigned To Doc. No." = CustomerOrderHeader."No.", CustOrderPaymentAssignedToDocNoErr);
        Assert.IsTrue(CustomerOrderPayment."Assigned To Doc. No." = PostedCustomerOrderHeader."No.", CustOrderPaymentAssignedToDocNoErr);
    end;

    [Test]
    [HandlerFunctions('ConfirmTrue,ModalPageHandlerCustomerOrderPayments,PageHandlerPostedCustomerOrder')]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure CheckTotalOrdersAmountOnCustomerCard()
    var
        CustomerOrderHeader: Record "Customer Order Header";
        CustomerOrderPayment: Record "Customer Order Payment";
        Customer: Record Customer;
        CustomerOrderPage: TestPage "Customer Order";
    begin
        // [GIVEN]
        CreateCustomerOrder(CustomerOrderHeader);
        CustomerOrderHeader.CalcFields("Total Order Amount");
        CreateCustomerPayment(CustomerOrderPayment, CustomerOrderHeader);

        // [WHEN]
        CustomerOrderPage.OpenEdit();
        CustomerOrderPage.GoToRecord(CustomerOrderHeader);
        CustomerOrderPage."Set payment".Invoke();
        CustomerOrderPage.Post.Invoke();

        // [THEN]
        Customer.SetLoadFields("Customer Orders Total");
        Customer.Get(CustomerOrderHeader."Customer No.");
        Customer.CalcFields("Customer Orders Total");

        Assert.AreEqual(CustomerOrderHeader."Total Order Amount", Customer."Customer Orders Total", CustOrderAmountErr);
    end;

    [Test]
    [HandlerFunctions('ModalPageHandlerCustomerOrderPayments')]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure CheckErrorOnSetPaymentActionOnCustOrder()
    var
        CustomerOrderHeader: Record "Customer Order Header";
        CustomerOrderPayment: Record "Customer Order Payment";
        CustomerOrderPage: TestPage "Customer Order";
    begin
        // [GIVEN]
        CreateCustomerOrder(CustomerOrderHeader);
        CustomerOrderHeader.CalcFields("Total Order Amount");
        CreateCustomerPayment(CustomerOrderPayment, CustomerOrderHeader);

        // [WHEN]
        CustomerOrderPayment."Paid Amount" += CustomerOrderPayment."Paid Amount";
        CustomerOrderPayment.Modify();

        CustomerOrderPage.OpenEdit();
        CustomerOrderPage.GoToRecord(CustomerOrderHeader);

        // [THEN]
        asserterror CustomerOrderPage."Set payment".Invoke();
        Assert.ExpectedError(PaidAmountMoreThenOrderAmountErr);
    end;


    // HANDLERS
    [ConfirmHandler]
    procedure ConfirmTrue(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;

    [ModalPageHandler]
    procedure ModalPageHandlerCustomerOrderPayments(var PageVar: TestPage "Customer Order Payments")
    begin
        PageVar.First();
        PageVar.OK().Invoke();
    end;

    [PageHandler]
    procedure PageHandlerPostedCustomerOrder(var PageVar: TestPage "Posted Customer Order")
    begin
        PageVar.Close();
    end;


    // ADDTIONAL PROCEDURES
    local procedure CreateCustomerOrder(var CustomerOrderHeader: Record "Customer Order Header")
    var
        CustomerOrderLine: Record "Customer Order Line";
    begin
        CustomerOrderHeader.Init();
        CustomerOrderHeader.Validate("Customer No.", LibrarySales.CreateCustomerNo());
        CustomerOrderHeader.Insert(true);

        CreateCustomerOrderLine(CustomerOrderLine, CustomerOrderHeader."No.");
    end;

    local procedure CreateCustomerOrderLine(var CustomerOrderLine: Record "Customer Order Line"; DocNo: Code[20])
    var
        Item: Record Item;
        Location: Record Location;
    begin
        LibraryInventory.CreateItem(Item);

        CustomerOrderLine.Init();
        CustomerOrderLine."Document No." := DocNo;
        CustomerOrderLine."No." := Item."No.";
        CustomerOrderLine."Line No." := 10000;
        CustomerOrderLine."Location Code" := LibraryWarehouse.CreateLocation(Location);
        CustomerOrderLine.Validate(Quantity, LibraryRandom.RandInt(3));
        CustomerOrderLine.Validate("Unit Price", LibraryRandom.RandDec(3, 3));
        CustomerOrderLine.Insert();
    end;

    local procedure CreateCustomerPayment(var CustomerOrderPayment: Record "Customer Order Payment"; CustomerOrderHeader: Record "Customer Order Header")
    begin
        CustomerOrderPayment.Init();
        CustomerOrderPayment."Pay to Customer No." := CustomerOrderHeader."Customer No.";
        CustomerOrderPayment."Paid Amount" := CustomerOrderHeader."Total Order Amount";
        CustomerOrderPayment.Insert(true);
    end;

    local procedure ClearUnitPriceOnCustomerOrderLine(CustomerOrderHeader: Record "Customer Order Header")
    var
        CustomerOrderLine: Record "Customer Order Line";
    begin
        CustomerOrderLine.SetRange("Document No.", CustomerOrderHeader."No.");
        CustomerOrderLine.SetLoadFields("Unit Price");

        if CustomerOrderLine.FindSet() then
            repeat
                CustomerOrderLine.Validate("Unit Price", 0);
                CustomerOrderLine.Modify();
            until CustomerOrderLine.Next() = 0;
    end;
}
