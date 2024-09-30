fn main() {
    println!("cargo:rustc-link-arg=-Tlinker.ld");
    println!("cargo:rustc-link-arg=--Map=target/map");

    println!("cargo:rerun-if-changed=linker.ld");
}
