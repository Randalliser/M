let
    getCodeFromGithub = (masterPath as text, blobPath as text) =>
        let
            /*  debug parameters
                masterPath = "https://github.com/ImkeF/RM/tree/master",
                blobPath = "https://github.com/ImkeF/RM/blob/master",
            */
            fileEndings = {".pq", ".m"},
            source = Web.Page(Web.Contents(masterPath)),
            data0 = source{0}[Data],
            columnFunctionNames = Table.ColumnNames(data0){1},
            filteredRows = Table.SelectRows(
                data0,
                each
                    List.AnyTrue(
                        List.Transform(
                            fileEndings, (list) => Text.EndsWith(Record.Field(_, columnFunctionNames), list)
                        )
                    )
            ),
            createURL = Table.AddColumn(
                filteredRows, "URLFunctionCode", each blobPath & "/" & Record.Field(_, columnFunctionNames)
            ),
            getCode = Table.AddColumn(
                createURL,
                "GetCode",
                each Text.Combine(Web.Page(Web.Contents([URLFunctionCode]))[Data]{0}[Column2], "#(lf)")
            ),
            removedOtherColumns = Table.SelectColumns(getCode, {"GetCode", columnFunctionNames}),
            renamedColumns = Table.RenameColumns(removedOtherColumns, {{columnFunctionNames, "Name"}}),
            cleanFunctionName = Table.TransformColumns(
                renamedColumns,
                {{"Name", each Text.BeforeDelimiter(_, ".", {0, RelativePosition.FromEnd}), type text}}
            ),
            evaluate = Table.AddColumn(cleanFunctionName, "TestCode", each Expression.Evaluate([GetCode], #shared))
        in
            evaluate,
    documentation = [
        Documentation.Name = " fngetCodeFromGithub#(lf)",
        Documentation.Description = " Fetches function code from GitHub#(lf)",
        Documentation.Category = " Accessing data#(lf)",
        Documentation.Author = " Imke Feldmann: www.TheBIccountant.com#(lf)",
        Documentation.Examples = {
            [
                Description = " 1) Path to repo main page 2) Path to the single files#(lf)",
                Code = " Check this blogpost: http://wp.me/p6lgsG-Gx explaining how it works#(lf)",
                Result = "#(lf)"
            ]
        }
    ]
in
    Value.ReplaceType(getCodeFromGithub, Value.ReplaceMetadata(Value.Type(getCodeFromGithub), documentation))
