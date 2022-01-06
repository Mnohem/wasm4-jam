const w4 = @import("wasm4.zig");
pub const Sound = struct {
    frequency: u32,
    volume: u32,
    duration: u32,
    flags: u32,
    
    const Self = @This();
    pub fn new(opt: SoundFormat) Self {
        return Self {
            .frequency = opt.freq1 | opt.freq2 << 16,
            .volume = opt.volume,
            .duration = opt.attack << 24 | opt.decay << 16 | opt.sustain | opt.release << 8,
            .flags = opt.channel | opt.mode << 2,
        };
    }
    
    pub fn play(self: Self) void {
        return w4.tone(self.frequency, self.duration, self.volume, self.flags);
    }
};
const SoundFormat = struct { 
    freq1: u32, freq2: u32, 
    attack: u32 = 60, decay: u32 = 0, sustain: u32 = 130, release: u32 = 32,
    volume: u32 = 100,
    channel: u32 = 1, mode: u32 = 2
};
