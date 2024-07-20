// SPDX-Licence-Identifier: MIT

pragma solidity 0.8.19;

contract SaiToken {
    error InsufficientBalance(uint256 available, uint256 required);
    mapping(address => uint256) private s_balances;

    function name() public pure returns (string memory) {
        return "Sai Coin";
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public pure returns (uint256) {
        return 1000 ether;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 _amount) public {
        if (balanceOf(msg.sender) < _amount) {
            revert InsufficientBalance({
                available: balanceOf(msg.sender),
                required: _amount
            });
        }
        uint256 prevBalance = balanceOf(msg.sender) + balanceOf(_to);
        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;
        require(balanceOf(msg.sender) + balanceOf(_to) == prevBalance);
    }
}
