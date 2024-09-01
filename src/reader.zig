const std = @import("std");
const testing = std.testing;

pub fn read_i8(buffer: []u8, offset: u32) i8 {
    return @bitCast(buffer[offset]);
}
pub fn read_u8(buffer: []u8, offset: u32) u8 {
    return buffer[offset];
}

pub fn read_i32(buffer: []u8, offset: u32) i32 {
    return std.mem.readInt(i32, @as(*const [4]u8, @ptrCast(buffer.ptr + offset)), .little);
}
pub fn read_u32(buffer: []u8, offset: u32) u32 {
    return std.mem.readInt(u32, @as(*const [4]u8, @ptrCast(buffer.ptr + offset)), .little);
}

pub fn read_i64(buffer: []u8, offset: u32) u64 {
    return std.mem.readInt(i64, @as(*const [4]u8, @ptrCast(buffer.ptr + offset)), .little);
}
pub fn read_u64(buffer: []u8, offset: u32) u64 {
    return std.mem.readInt(u64, @as(*const [4]u8, @ptrCast(buffer.ptr + offset)), .little);
}

pub fn read_double(buffer: []u8, offset: u32) f64 {
    const ptr = @as(*const [8]u8, @ptrCast(buffer[offset..].ptr));
    return @as(f64, @bitCast(std.mem.readInt(i64, ptr, .little)));
}

pub fn read_bool(buffer: []u8, offset: u32) bool {
    return buffer[offset] == 1;
}

pub fn read_type_id(buffer: []u8) u32 {
    return read_u32(buffer, 0);
}

pub fn read_field_size(buffer: []u8, field_number: u32) u32 {
    return read_u32(buffer, 4 * (field_number + 1));
}

test "read int" {
    const bytes = [5]u8{ 0, 4, 0, 0, 0 };
    try testing.expect(read_u32(@constCast(&bytes), 1) == 4);
}

test "read double" {
    const bytes = [8]u8{ 0xAE, 0x47, 0xE1, 0x7A, 0x14, 0xAE, 0xF3, 0x3F };
    try testing.expect(read_double(@constCast(&bytes), 0) == 1.23);
}
