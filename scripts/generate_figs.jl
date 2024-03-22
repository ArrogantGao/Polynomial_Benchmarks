using Plots, CSV, DataFrames, ArgParse

function parse_commandline()

	s = ArgParseSettings()

	@add_arg_table s begin
		"--in-file"
		help = "relative file path of the output file"
	end

	return parse_args(s)

end

function generate_fig()
    
    parsed_args = parse_commandline()
    in_file = parsed_args["in-file"]
    dic = dirname(in_file)
    
    df0 = CSV.read(in_file, DataFrame)
    for T0 in ["Float32", "Float64"]
        df = filter(row -> row.T == T0, df0)
        plot(xlabel = "log2(n)", ylabel = "log10(t)", title = "Estrin vs Horner vs Polynomials.jl ($T0)", legend = :topleft, dpi = 500, xlim = [minimum(df.n) - 1, maximum(df.n) + 1])
        plot!(df.n, log10.(df.et), label = "Estrin", marker = :circle)
        plot!(df.n, log10.(df.ht), label = "Horner", marker = :square)
        plot!(df.n, log10.(df.pt), label = "Polynomials.jl", marker = :diamond)

        savefig(joinpath(dic, "estrin_vs_horner_vs_polynomial_$T0.png"))
    end

    nothing
end

generate_fig()