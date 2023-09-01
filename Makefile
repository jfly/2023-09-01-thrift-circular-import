ENUM_VALUE_COUNT ?= 2000

.PHONY: repro
repro: gen-thrift-source
	(cd generated; thrift --allow-64bit-consts --gen py:slots foo.thrift)

.PHONY: gen-thrift-source
gen-thrift-source:
	mkdir -p generated
	echo 'include "bar.thrift"' > generated/foo.thrift
	printf 'include "large-enum.thrift"\ninclude "foo.thrift"' > generated/bar.thrift
	python -c 'print("enum LargeEnum {"); print("\n".join(f"    FOO{i} = {i}," for i in range(${ENUM_VALUE_COUNT}))); print("}\n");' > generated/large-enum.thrift

.PHONY: clean
clean:
	rm -r generated
