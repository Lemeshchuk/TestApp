reportextension 50100 "Stand. Sales Invoice" extends "Standard Sales - Invoice"
{
    dataset
    {
        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            begin
                LineNo := '';
                if Line.Type <> Line.Type::" " then begin
                    LineNumber += 1;
                    LineNo := Format(LineNumber);
                end;
            end;
        }

        add(Header)
        {
            column(CompanyFullName; CompInfo."Name 2") { }
            column(DirectorJobTitle; DirectorJobTitle) { }
            column(TotalLines; TotalLinesCount) { }
        }

        add(Line)
        {
            column(LineNo; LineNo) { }
        }

        add(Totals)
        {
            column(TotalAmountInclVATText; TotalAmountInclVATText) { }
            column(TotalAmountExlVATText; TotalAmountExlVATText) { }
        }
    }

    var
        CompInfo: Record "Company Information";
        DirectorJobTitle: Text[250];
        TotalAmountInclVATText: Text;
        TotalAmountExlVATText: Text;
        LineNo: Text;
        TotalLinesCount: Integer;
        LineNumber: Integer;

}
