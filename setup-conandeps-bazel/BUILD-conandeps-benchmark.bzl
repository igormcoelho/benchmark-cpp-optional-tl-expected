
#filegroup(
#    name = "benchmark_binaries",
#    data = glob(["**"]),
#    visibility = ["//visibility:public"],
#)

cc_import(
    name = "benchmark_precompiled",
    static_library = "lib/libbenchmark.a",
   # visibility = ["//visibility:public"],
)

cc_import(
    name = "benchmark_main_precompiled",
    static_library = "lib/libbenchmark_main.a",
    #visibility = ["//visibility:public"],
)


cc_library(
    name = "benchmark",
    includes = ["include"],
    hdrs = glob(["include/**"]),
    deps = [":benchmark_precompiled"],
    linkopts = ["-lpthread"],
    visibility = ["//visibility:public"]
)
