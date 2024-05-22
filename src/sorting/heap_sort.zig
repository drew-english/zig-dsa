const std = @import("std");

fn left_child(i: usize) usize {
    return 2 * i + 1;
}

fn heap_sort(array: []i32) void {
    var start = array.len / 2; // leaf nodes are balanced, start at first inner node
    var end = array.len;

    while (end > 1) {
        if (start > 0) {
            // p1: building max heap
            start = start - 1;
        } else {
            // p2: using built max heap to order array
            end = end - 1;

            // insert max of heap at last unsorted spot in array
            const temp = array[end];
            array[end] = array[0];
            array[0] = temp;
        }

        // balance sub tree of max heap
        // p1: bottom -> up
        // p2: heap root replaced -> balance heap
        var root = start;
        while (left_child(root) < end) {
            // find largest child of left and right nodes
            var child = left_child(root);
            if (child + 1 < end and array[child] < array[child + 1]) {
                child = child + 1;
            }

            // swap when parent is not ordered properly
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

test heap_sort {
    const n = 20;
    const random = std.crypto.random;

    var array: [n]i32 = undefined;
    for (0..n) |i| {
        array[i] = random.int(i32);
    }

    heap_sort(&array);
    for (1..n) |i| {
        try std.testing.expect(array[i - 1] <= array[i]);
    }
}
