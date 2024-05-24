const std = @import("std");

fn swap(array: []i32, idx1: usize, idx2: usize) void {
    const tmp = array[idx1];
    array[idx1] = array[idx2];
    array[idx2] = tmp;
}

/// Quick sort algorithm using the Lomuto partitioning scheme
fn lomuto_quick_sort(array: []i32, low: usize, high: usize) void {
    // Recursive base case
    // cannot have low < 0 with usize
    if (low >= high) {
        return;
    }

    // Calculate pivot position where all LHS <= array[pivot]
    // and all RHS > array[pivot]
    const pivot = lomuto_partition(array, low, high);

    // Overflow protection
    if (pivot > 0) {
        // Recursively sort LHS
        lomuto_quick_sort(array, low, pivot - 1);
    }

    // Recursively sort RHS
    lomuto_quick_sort(array, pivot + 1, high);
}

fn lomuto_partition(array: []i32, low: usize, high: usize) usize {
    // Simply choose last item as pivot value
    const p_val = array[high];

    // Track pivot index separately
    var p_idx = low;

    // Sort values around pivot
    for (low..high) |j| {
        if (array[j] <= p_val) {
            swap(array, p_idx, j);
            p_idx = p_idx + 1;
        }
    }

    // Put pivot value in correct place
    swap(array, p_idx, high);
    return p_idx;
}

test lomuto_quick_sort {
    const n = 20;
    const random = std.crypto.random;

    var array: [n]i32 = undefined;
    for (0..n) |i| {
        array[i] = random.int(i32);
    }

    lomuto_quick_sort(&array, 0, array.len - 1);
    for (1..n) |i| {
        try std.testing.expect(array[i - 1] <= array[i]);
    }
}

/// Quick sort algorith using the Hoare paritioning scheme
fn hoare_quick_sort(array: []i32, low: usize, high: usize) void {
    if (low >= high) {
        return;
    }

    const pivot = hoare_partition(array, low, high);
    hoare_quick_sort(array, low, pivot);
    hoare_quick_sort(array, pivot + 1, high);
}

fn hoare_partition(array: []i32, low: usize, high: usize) usize {
    const p_val = array[low];
    var i = low;
    var j = high;

    while (true) {
        while (array[i] < p_val) : (i += 1) {}
        while (array[j] > p_val) : (j -= 1) {}
        if (i >= j) {
            return j;
        }

        swap(array, i, j);
    }
}

test hoare_quick_sort {
    const n = 20;
    const random = std.crypto.random;

    var array: [n]i32 = undefined;
    for (0..n) |i| {
        array[i] = random.int(i32);
    }

    hoare_quick_sort(&array, 0, array.len - 1);
    for (1..n) |i| {
        try std.testing.expect(array[i - 1] <= array[i]);
    }
}
