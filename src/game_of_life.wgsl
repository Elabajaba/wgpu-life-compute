// Shader from https://github.com/jakobhellermann/bevy/blob/shader-examples/assets/shaders/game_of_life.wgsl
// All credit to JakobHellermann for actually writing the shader

[[group(0), binding(0)]]
var texture: texture_storage_2d<rgba8unorm, read_write>;

fn hash(value: u32) -> u32 {
    var state = value;
    state = state ^ 2747636419u;
    state = state * 2654435769u;
    state = state ^ state >> 16u;
    state = state * 2654435769u;
    state = state ^ state >> 16u;
    state = state * 2654435769u;
    return state;
}
fn randomFloat(value: u32) -> f32 {
    return f32(hash(value)) / 4294967295.0;
}

[[stage(compute), workgroup_size(8, 8, 1)]]
fn init([[builtin(global_invocation_id)]] invocation_id: vec3<u32>,
    [[builtin(num_workgroups)]] num_workgroups: vec3<u32>,) {
    let location = vec2<i32>(i32(invocation_id.x), i32(invocation_id.y));
    let location_f32 = vec2<f32>(f32(invocation_id.x), f32(invocation_id.y));

    let randomNumber = randomFloat(invocation_id.y * num_workgroups.x + invocation_id.x);
    let alive = randomNumber > 0.9;
    let color = vec4<f32>(f32(alive));

    textureStore(texture, location, color);
}


fn get(location: vec2<i32>, offset_x: i32, offset_y: i32) -> i32 {
    let value: vec4<f32> = textureLoad(texture, location + vec2<i32>(offset_x, offset_y));
    return i32(value.x);
}

fn count_alive(location: vec2<i32>) -> i32 {
    return get(location, -1, -1) +
           get(location, -1,  0) +
           get(location, -1,  1) +
           get(location,  0, -1) +
           get(location,  0,  1) +
           get(location,  1, -1) +
           get(location,  1,  0) +
           get(location,  1,  1);
}

[[stage(compute), workgroup_size(8, 8, 1)]]
fn update([[builtin(global_invocation_id)]] invocation_id: vec3<u32>) {
    let location = vec2<i32>(i32(invocation_id.x), i32(invocation_id.y));

    let n_alive = count_alive(location);
    let color = vec4<f32>(f32(n_alive) / 8.0);

    var alive: bool;
    if (n_alive == 3) {
        alive = true;
    } elseif (n_alive == 2) {
        let currently_alive = get(location, 0, 0);
        alive = bool(currently_alive);
    } else {
        alive = false;
    }

    storageBarrier();

    textureStore(texture, location, vec4<f32>(f32(alive)));
} 