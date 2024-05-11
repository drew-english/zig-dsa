const std = @import("std");

fn left_child(i: usize) usize {
    return 2 * i + 1;
}

fn heapSort(array: []i32) void {
    var start = array.len / 2;
    var end = array.len;

    while (end > 1) {
        if (start > 0) {
            start = start - 1;
        } else {
            end = end - 1;

            const temp = array[end];
            array[end] = array[0];
            array[0] = temp;
        }

        var root = start;
        while (left_child(root) < end) {
            var child = left_child(root);
            if (child + 1 < end and array[child] < array[child + 1]) {
                child = child + 1;
            }

            if (array[root] < array[child]) {
                const temp = array[root];
                array[root] = array[child];
                array[child] = temp;

                root = child;
            } else {
                break;
            }
        }
    }
}

pub fn main() void {
    const n = 20;
    const random = std.crypto.random;

    var array: [n]i32 = undefined;
    for (0..n) |i| {
        array[i] = random.int(i32);
    }

    heapSort(&array);
    std.debug.print("Sorted: {any}\n", .{array});
}
