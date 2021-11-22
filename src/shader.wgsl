// Vertex shader just generates a fullscreen triangle.
// Taken from https://www.saschawillems.de/blog/2016/08/13/vulkan-tutorial-on-rendering-a-fullscreen-quad-without-buffers/
// and autoconverted to wgsl using naga.
struct VertexOutput {
    [[location(0)]] outUV: vec2<f32>;
    [[builtin(position)]] member: vec4<f32>;
};

var<private> outUV: vec2<f32>;
var<private> gl_VertexIndex: u32;
var<private> gl_Position: vec4<f32>;

fn main_1() {
    let e2: u32 = gl_VertexIndex;
    let e9: u32 = gl_VertexIndex;
    outUV = vec2<f32>(f32(((e2 << u32(1)) & u32(2))), f32((e9 & u32(2))));
    let e17: vec2<f32> = outUV;
    gl_Position = vec4<f32>(((e17 * 2.0) + vec2<f32>(-(1.0))), 0.0, 1.0);
    return;
}

[[stage(vertex)]]
fn vs_main([[builtin(vertex_index)]] param: u32) -> VertexOutput {
    gl_VertexIndex = param;
    main_1();
    let e5: vec2<f32> = outUV;
    let e7: vec4<f32> = gl_Position;
    return VertexOutput(e5, e7);
}

// Fragment shader just outputs our game of life.
// [[group(0), binding(0)]]
// var t_diffuse: texture_2d<f32>;
// [[group(0), binding(1)]]
// var s_diffuse: sampler;

[[stage(fragment)]]
fn fs_main(in: VertexOutput) -> [[location(0)]] vec4<f32> {
    return vec4<f32>(1.0, 0.0, 0.0, 1.0);
    // return textureSample(t_diffuse, s_diffuse, in.outUV);
}