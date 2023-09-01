Reproduce some bizarre behavior of the thrift compiler.

Dangerous command to run:

    $ systemd-run --user --scope --property=MemoryMax=4G make repro
    Running scope as unit: run-rdd800bee321a4f49a38fa7b1dcefebb5.scope
    mkdir -p generated
    echo 'include "bar.thrift"' > generated/foo.thrift
    printf 'include "large-enum.thrift"\ninclude "foo.thrift"' > generated/bar.thrift
    python -c 'print("enum LargeEnum {"); print("\n".join(f"    FOO{i} = {i}," for i in range(2000))); print("}\n");' > generated/large-enum.thrift
    (cd generated; thrift --allow-64bit-consts --gen py:slots foo.thrift)
    make: *** [Makefile:3: repro] Terminated
    [1]    49796 terminated  systemd-run --user --scope --property=MemoryMax=4G make repro
