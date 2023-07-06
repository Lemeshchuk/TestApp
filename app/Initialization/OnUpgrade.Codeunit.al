codeunit 50106 OnUpgrade
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        InitializationMgt: Codeunit InitializationMgt;
        ModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(ModuleInfo);
        PurchSetup.Get();

        if ModuleInfo.AppVersion.Major = 2 then begin
            PurchSetup."Order Nos." := InitializationMgt.CreateNoSeries('NEWCUSTORD', 'NEW CUSTOMER ORDER');
            PurchSetup."Posted Invoice Nos." := InitializationMgt.CreateNoSeries('NEWPCUSTORD', 'NEW POSTED CUSTOMER ORDER');
            PurchSetup."Quote Nos." := InitializationMgt.CreateNoSeries('NEWPAYTOCUST', 'NEW CUSTOMER ORDER PAYMENT');
            PurchSetup.Modify();
        end;
    end;
}
