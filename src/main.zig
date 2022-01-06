const std = @import("std");
const w4 = @import("wasm4.zig");

const Sprite = @import("sprite.zig").Sprite;
const Movement = @import("sprite.zig").Movement;
const Sound = @import("sound.zig").Sound;

const funny_image = [32]u8{ 0xfe,0x7f,0xfd,0xbf,0xfb,0xdf,0xfd,0xbf,0xfd,0xbf,0xfd,0xbf,0xfd,0xbf,0xfd,0xbf,0xfd,0xbf,0xf3,0xcf,0xef,0xf7,0xef,0xf7,0xf7,0xef,0xf8,0x1f,0xff,0xff,0xff,0xff };
var funny = Sprite {
    .width = 16, .height = 16,
    .flags = w4.BLIT_1BPP,
    .image = &funny_image,
    .x = 76, .y = 50,
};

const falling = Sound.new(.{ .freq1 = 40, .freq2 = 440 });
const rising = Sound.new(.{ .freq1 = 440, .freq2 = 40 });

var heap: [100]u8 = undefined;
var fba = std.heap.FixedBufferAllocator.init(&heap);
const alloc = fba.allocator();

var frame: u8 = 0;

export fn update() void {
    
    w4.DRAW_COLORS.* = 0x402;
    
    const frame_display = std.fmt.allocPrint(alloc, "{d:3}", .{frame}) catch unreachable;
    defer alloc.free(frame_display);
    w4.text(frame_display.ptr, 4, 4);
    
    frame +%= 1;
    
    w4.text("Hello from Zig!", 10, 20);

    const gamepad = w4.GAMEPAD1.*;
    
    if ((gamepad & w4.BUTTON_1) != 0)
        falling.play();
    
    if ((gamepad & w4.BUTTON_2) != 0)
        rising.play();
    
    var movement = @bitCast(Movement, gamepad);
    movement.step = 1;
    funny.move(movement);
    
    funny.display();
    w4.text("Press X to fall!", 16, 90);
}

