pragma solidity ^0.4.21;

import "./Exchange.sol";
import "./LinkedList.sol";

contract GreedyExchange is Exchange {
    using SortedLinkedListLib for SortedLinkedListLib.LinkedList;
    SortedLinkedListLib.LinkedList tokenContributeList;

    ExchangeToken ext = new ExchangeToken();

    //Adding EXT(ExchangeToken) to this exchange and sell it for 10 wei
    constructor () public {
        tokenIndex++;
        tokens[tokenIndex].symbolName = "EXT";
        tokens[tokenIndex].tokenContract = ext;
        emit TokenAddedToSystem(tokenIndex, "EXT", now);
        tokenBalanceForAddress[msg.sender][1] = 1000000;

        //makes sell bid on the exchange
        sellToken("EXT", 10, 1000000);
    }

    function increaseExtDeposit(string symbolName, uint amount) public  {
        require(tokenBalanceForAddress[msg.sender][1] > amount);
        require(amount > 0 );
        require(hasToken(symbolName));

        uint8 tokenIndex = getSymbolIndexOrThrow(symbolName);
        tokenBalanceForAddress[msg.sender][1] -= amount;

        tokenContributeList.removeNode(tokenIndex);
        tokenContributeList.insertInSortedOrder(tokenIndex, amount);
    }

    function amountOfExtDeposit(string symbolName) public view returns (uint) {
        uint8 tokenIndex = getSymbolIndexOrThrow(symbolName);
        return tokenContributeList.getValueOfNode(tokenIndex);
    }

    function getTop3Tokens() public view returns (uint8[3]) {
        tokenContributeList.getTop3();
    }

    function exchangeTokenAddress () public view returns(address) {
        return ext;
    }
}
