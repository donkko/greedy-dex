pragma solidity ^0.4.18;
pragma experimental ABIEncoderV2;

library SortLib {
    struct Node{
        uint256 nodeId;
        uint256 value;
    }

    function sort(Node[] storage self) public returns(Node[]) {
        quickSort(self, int(0), int(self.length - 1));
        return self;
    }

    function quickSort(Node[] storage self, int left, int right) internal{
        int i = left;
        int j = right;
        if (i == j) return;

        uint pivot = self[uint(left + (right - left) / 2)].value;
        while (i <= j) {
            while (self[uint(i)].value < pivot) i++;
            while (pivot < self[uint(j)].value) j--;
            if (i <= j) {
                (self[uint(i)], self[uint(j)]) = (self[uint(j)], self[uint(i)]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(self, left, j);
        if (i < right)
            quickSort(self, i, right);
    }
}

contract QuickSortTest {
    using SortLib for SortLib.Node[];
    SortLib.Node[] array;

    function populate () public returns (bool) {
        array.push(SortLib.Node(1, 111));
        array.push(SortLib.Node(2, 222));
        array.push(SortLib.Node(4, 444));
        array.push(SortLib.Node(3, 333));
        array.push(SortLib.Node(5, 555));

        return true;
    }

    function insertAndSort () public returns (bool) {
        array.push(SortLib.Node(6, 666));
        array.sort();

        return true;
    }
}
