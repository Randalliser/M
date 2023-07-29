let
    func = (x, operations) =>
        List.Accumulate(operations, x, (state, current) => Function.Invoke(current{0}, {state} & List.Skip(current))),
    documentation = [
        Documentation.Name = " Syntax.Pipe#(lf)",
        Documentation.Description = " Allows to use piping-syntax.#(lf)",
        Documentation.LongDescription = " Allows to use piping-syntax: http://www.thebiccountant.com/2017/08/16/should-we-pipe-m/#(lf)",
        Documentation.Category = " Documentation#(lf)",
        Documentation.Source = "  http://www.thebiccountant.com/2017/08/16/should-we-pipe-m/ .#(lf)",
        Documentation.Author = " Imke Feldmann: www.TheBIccountant.com .#(lf)",
        Documentation.Examples = {[
            Description = "#(lf)",
            Code = "#(lf)",
            Result = "#(lf)"
        ]}
    ]
in
    Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
