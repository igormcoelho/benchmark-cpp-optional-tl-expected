
load("@rules_cc//cc:defs.bzl", "cc_import", "cc_library")

cc_library(
    name = "tl-expected",
    hdrs = glob(["include/**"]),
    includes = ["include"],
    visibility = ["//visibility:public"]
)
