codeunit 50105 InitializationMgt
{
    internal procedure CreateNoSeries(Code: Code[20]; Description: Text[100]): Code[20]
    var
        NoSeries: Record "No. Series";
    begin
        If not NoSeries.Get(Code) then begin
            NoSeries.Init();
            NoSeries.Code := Code;
            NoSeries.Description := Description;
            NoSeries."Default Nos." := true;
            NoSeries.Insert(true);
        end;
        CreateNoSeriesLine(Code);
        exit(NoSeries.Code);
    end;

    local procedure CreateNoSeriesLine(Code: Code[20])
    var
        NoSeriesLine: Record "No. Series Line";
    begin
        If not NoSeriesLine.Get(Code, 10000) then begin
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := Code;
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine.Validate("Starting No.", Code + '001');
            NoSeriesLine.Validate("Ending No.", Code + '100');
            NoSeriesLine.Validate("Increment-by No.", 1);
            NoSeriesLine."Sequence Name" := Code;
            NoSeriesLine."Allow Gaps in Nos." := true;
            NoSeriesLine.Insert(true);
        end;
    end;
}
