all:  conan-bazel-bench  # bench

bench:
	mkdir -p build
	g++ -fno-exceptions -std=c++17 -Ofast -I./libs/ bench.cpp -o build/app_bench

conan-bazel-bench: get_conan_packages_dev
	bazel build //:app_bench -s --cxxopt='-DNDEBUG --std=c++17' # --verbose_failures # --sandbox_debug
	./bazel-bin/app_bench

get_conan_packages_dev:
	@echo "==========================================================="
	@echo "will download packages to user local .conan folder         "
	@echo "-> user can override this with CONAN_USER_HOME variable    "
	@echo "bazel build files will be located on conandeps-dev/ folder "
	@echo "==========================================================="
	mkdir -p conandeps-dev/
	cp setup-conandeps-bazel/conanfile-conandeps.py conandeps-dev/conanfile.py
	# export CONAN_USER_HOME=${PWD}/conandeps-dev/conan_packages && cd conandeps-dev && conan install . -s compiler.libcxx=libstdc++11
	cd conandeps-dev && conan install . -s compiler.libcxx=libstdc++11
	cp setup-conandeps-bazel/BUILD-conandeps-benchmark.bzl conandeps-dev/benchmark/BUILD
	cp setup-conandeps-bazel/BUILD-conandeps-tl-expected.bzl conandeps-dev/tl-expected/BUILD
	@echo "================================================"
	@echo "FINISHED! just type: bazel run //:app_bench"
	@echo "================================================"

clean_bazel_deps_dev:
	rm -f  conandeps-dev/dependencies.bzl
	rm -rf conandeps-dev/tl-expected
	rm -rf conandeps-dev/benchmark
	# delete all conandeps
	rm -rf conandeps-dev/

clean:
	rm -f *.gcda
	rm -f *.gcno
	rm -f *_test
