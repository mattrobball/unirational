using Oscar
t = character_table("L2(11)")
show(stdout, MIME("text/plain"), t)
println()
println("orders of class representatives: ", orders_class_representatives(t))
println("class sizes: ", class_lengths(t))
