codeunit 50104 OnInstall
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        InitializationMgt: Codeunit InitializationMgt;
        ModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(ModuleInfo);
        PurchSetup.Get();

        if ModuleInfo.AppVersion.Major = 1 then begin
            PurchSetup."Order Nos." := InitializationMgt.CreateNoSeries('CUSTORD', 'CUSTOMER ORDER');
            PurchSetup."Posted Invoice Nos." := InitializationMgt.CreateNoSeries('PCUSTORD', 'POSTED CUSTOMER ORDER');
            PurchSetup."Quote Nos." := InitializationMgt.CreateNoSeries('PAYTOCUST', 'CUSTOMER ORDER PAYMENT');
            PurchSetup.Modify();
        end;
    end;
}

