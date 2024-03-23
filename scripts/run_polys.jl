using ArgParse, Estrin, BenchmarkTools, Polynomials, CSV, DataFrames

function parse_commandline()

	s = ArgParseSettings()

	@add_arg_table s begin
		"--output-file"
		help = "relative file path of the output file"
	end

	return parse_args(s)

end

function main()

	parsed_args = parse_commandline()
	output_file = parsed_args["output-file"]

	for T in [Float32, Float64]
		for n in 1:16
			coeffs = randn(T, 2^n)
			poly_estrin = Poly(coeffs)
			poly = Polynomial(coeffs)
			x0 = T(0.9)
			estrin_runtime = @belapsed estrin_rule($x0, $poly_estrin)
			estrin_tile_runtime = @belapsed estrin_rule_tile($x0, $poly_estrin)
			horner_runtime = @belapsed horner_rule($x0, $poly_estrin)
			polynomial_runtime = @belapsed $poly($x0)
			@show T, n, estrin_runtime, estrin_tile_runtime, horner_runtime, polynomial_runtime
			df = DataFrame(n = n, T = T, et = estrin_runtime, ett = estrin_tile_runtime, ht = horner_runtime, pt = polynomial_runtime)
			CSV.write(output_file, df, append = true)
		end
	end

	nothing
end

main()
