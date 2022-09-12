# benchmark-cpp-optional-tl-expected
Small benchmark for C++ std::optional and tl::expected

## How to build

### Simple (with GNU Make + Conan + Bazel)

- `pip install conan`
- Install Bazel (using NPM Bazelisk?)
- `make` or `make conan-bazel-bench`

This project uses Conan repository for dependencies `tl-expected` and `benchmark`.
Step by step:

- Conan will get dependencies and put on `conandeps-dev` folder.
- Build scripts from `setup-conandeps-bazel` will be copied into `conandeps-dev` folder.
- Bazel will build benchmark on `src/` and include the dependencies

### Complex

One can manually download dependencies from conan and setup conandeps-dev folder.

Inspecting conan dependencies from `conancenter` repo:

- `conan search benchmark -r conancenter`
- `conan search tl-expected -r conancenter`

Setup `conandeps-dev` folder:

- mkdir -p conandeps-dev/
- cp setup-conandeps-bazel/conanfile-conandeps.py conandeps-dev/conanfile.py

Install conan packages on specific location (e.g, `conandeps-dev/conan_packages`):

- mkdir -p conandeps-dev/conan_packages
- export CONAN_USER_HOME=${PWD}/conandeps-dev/conan_packages && cd conandeps-dev && conan install . -s compiler.libcxx=libstdc++11

Or just use default conan location:

- cd conandeps-dev && conan install . -s compiler.libcxx=libstdc++11

Manually copy the BUILD files for bazel on each package:

- cp setup-conandeps-bazel/BUILD-conandeps-benchmark.bzl conandeps-dev/benchmark/BUILD
- cp setup-conandeps-bazel/BUILD-conandeps-tl-expected.bzl conandeps-dev/tl-expected/BUILD

Build and run with bazel:

- bazel build //:app_bench -s --cxxopt='-DNDEBUG --std=c++17'
- ./bazel-bin/app_bench


#### Listing Bazel dependencies

```
bazel query 'labels(hdrs, @tl-expected//...)'
bazel query 'labels(hdrs, @benchmark//...)'
bazel query 'labels(hdrs, ...)'
bazel query 'labels(srcs, ...)'
```

## Expected Results

Benchmark could be something like this:

```
---------------------------------------------------------------------------
Benchmark                                 Time             CPU   Iterations
---------------------------------------------------------------------------
bench_direct_int/10                    24.6 ns         24.4 ns     24629035
bench_direct_int/100                    416 ns          412 ns      1802191
bench_direct_int/1000                  4176 ns         4131 ns       170113
bench_optional_int/10                   126 ns          126 ns      5228559
bench_optional_int/100                 1268 ns         1265 ns       553864
bench_optional_int/1000               12664 ns        12638 ns        57489
bench_expected_int/10                  26.4 ns         26.4 ns     26910154
bench_expected_int/100                  398 ns          395 ns      1773433
bench_expected_int/1000                4003 ns         3987 ns       172317
bench_expected_int_int/10               125 ns          125 ns      5622592
bench_expected_int_int/100             1250 ns         1248 ns       529160
bench_expected_int_int/1000           12378 ns        12337 ns        57239
bench_anti_optional_int/10             57.4 ns         57.2 ns     12760791
bench_anti_optional_int/100             555 ns          553 ns      1211276
bench_anti_optional_int/1000           5677 ns         5655 ns       126745
bench_anti_expected_int/10             38.8 ns         38.7 ns     18068586
bench_anti_expected_int/100             335 ns          334 ns      2133460
bench_anti_expected_int/1000           3484 ns         3467 ns       212075
bench_anti_expected_int_int/10         74.4 ns         74.2 ns      8194440
bench_anti_expected_int_int/100         746 ns          743 ns       963001
bench_anti_expected_int_int/1000       7322 ns         7304 ns        97914
```

Later we plan to better analyze each result, but one can just look into `main.cpp` to see what was tested on `std::optional` and `tl::expected`.

For now, this is also a demo for Conan + Bazel, specially for Google Benchmark project, which is hard to integrate with simpler projects, like this (we hope to have made that simpler...).

## License

MIT License