use godot::prelude::*;

mod rust_example_node2d;

struct GdRustExample;

#[gdextension]
unsafe impl ExtensionLibrary for GdRustExample {}
