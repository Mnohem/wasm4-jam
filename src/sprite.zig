const w4 = @import("wasm4.zig");

pub const Sprite = struct {
    width: i32,
    height: i32,
    flags: u32,
    image: [*]const u8,
    x: u8,
    y: u8,
    
    const Self = @This();

    pub fn display(self: Self) void {
        w4.blit(self.image, self.x, self.y, self.width, self.height, self.flags);
    }
    
    pub fn move(self: *Self, m: Movement) void {
        self.*.y -= m.up * m.step;
        self.*.y += m.down * m.step;
        self.*.x -= m.left * m.step;
        self.*.x += m.right * m.step;
    }
};

pub const Movement = packed struct {
    step: u4,
    left: u1,
    right: u1,
    up: u1,
    down: u1,
};//Order matters for casting, least significant bits come first in struct declaration
