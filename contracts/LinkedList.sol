pragma solidity ^0.4.18;

library SortedLinkedListLib {
    struct Node {
        uint256 value;
        uint256 prevNodeId;
        uint256 nextNodeId;
    }

    struct LinkedList{
        mapping (uint256 => Node) list;
    }

    function init (LinkedList storage self) internal {
        Node memory headNode = Node(0, 0, 0);
        self.list[0] = headNode;
    }

    function nodeExists (LinkedList storage self, uint256 nodeId) internal view returns (bool) {
        return self.list[nodeId].value > 0;
    }

    function getValueOfNode (LinkedList storage self, uint256 nodeId) internal view returns (uint256) {
        return self.list[nodeId].value;
    }

    function getTop3 (LinkedList storage self) internal view returns (uint256[3]) {
        Node storage headNode = self.list[0];
        Node storage top1 = self.list[headNode.nextNodeId];
        Node storage top2 = self.list[top1.nextNodeId];
        return [headNode.nextNodeId, top1.nextNodeId, top2.nextNodeId];
    }

    function insertInSortedOrder (LinkedList storage self, uint256 nodeId, uint256 value) internal returns (bool) {
        require(nodeId > 0);
        require(value > 0);
        require(!nodeExists(self, nodeId));

        Node storage headNode = self.list[0];
        if (headNode.nextNodeId == 0) {
            headNode.nextNodeId = nodeId;
            self.list[nodeId] = Node(value, 0, 0);
            return true;
        }

        // traversal
        uint256 currentNodeId = headNode.nextNodeId;
        while(true) {
            Node storage currentNode = self.list[currentNodeId];

            if (currentNode.value >= value) {
                if (currentNode.nextNodeId == 0) {
                    self.list[nodeId] = Node(value, currentNodeId, 0);
                    currentNode.nextNodeId = nodeId;
                    break;
                } else {
                    currentNodeId = currentNode.nextNodeId;
                    continue;
                }
            } else {
                // insert node
                self.list[nodeId] = Node(value, currentNode.prevNodeId, currentNodeId);
                Node storage prevNode = self.list[currentNode.prevNodeId];
                currentNode.prevNodeId = nodeId;
                prevNode.nextNodeId = nodeId;
                break;
            }
        }
        return true;
    }

    function removeNode (LinkedList storage self, uint256 nodeId) internal returns (bool) {
        require(nodeId > 0);

        Node storage targetNode = self.list[nodeId];
        Node storage prevNode = self.list[targetNode.prevNodeId];
        Node storage nextNode = self.list[targetNode.nextNodeId];

        prevNode.nextNodeId = targetNode.nextNodeId;
        nextNode.prevNodeId = targetNode.prevNodeId;
        delete self.list[nodeId];

        return true;
    }
}

contract LinkedListTest {
    using SortedLinkedListLib for SortedLinkedListLib.LinkedList;
    SortedLinkedListLib.LinkedList linkedList;

    constructor () public {
        linkedList.init();
    }

    function populate () public returns (bool) {
        linkedList.insertInSortedOrder(1, 111);
        linkedList.insertInSortedOrder(2, 222);
        linkedList.insertInSortedOrder(4, 444);
        linkedList.insertInSortedOrder(3, 333);
        linkedList.insertInSortedOrder(5, 555);

        return true;
    }

    function insertAndSort () public returns (bool) {
        linkedList.insertInSortedOrder(6, 666);

        return true;
    }
}
