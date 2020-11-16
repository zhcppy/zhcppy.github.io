# DelegateCall

solidity里的delegatecall函数与call其实差不多，都是用来进行函数的调用，主要的区别在于二者执行代码的上下文环境的不同，
当使用call调用其它合约的函数时，代码是在被调用的合约的环境里执行，对应的，使用delegatecall进行函数调用时代码则是在调用函数的环境里执行。

DelegateCall是调用方合同如何调用目标合同函数的调用机制，但是当目标合同执行其逻辑时，上下文不在执行调用方合同的用户身上，而是在调用方合同上。

### 实现合约重用

```solidity
pragma solidity ^0.5.16;


contract DelegateProxy {

    address public owner;
    address private target;

    constructor(address _target) public {
        require(isContract(_target), "Invalid contract address");
        owner = msg.sender;
        target = _target;
    }

    function getTarget() public view returns (address) {
        return target;
    }

    function isContract(address _target) internal view returns (bool) {
        if (_target == address(0)) {
            return false;
        }

        uint256 size;
        assembly {size := extcodesize(_target)}
        return size > 0;
    }

    function() external payable {


        address _target = target;
        bytes memory _calldata = msg.data;

        assembly {
            let result := delegatecall(gas, _target, add(_calldata, 0x20), mload(_calldata), 0, 0)
            let size := returndatasize
            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)

            switch result
            case 0 {
                revert(ptr, size)
            }
            default {
                return (ptr, size)
            }
        }

//        assembly {
//        //0x40 is the address where the next free memory slot is stored in Solidity
//            let _calldataMemoryOffset := mload(0x40)
//        // new "memory end" including padding. The bitwise operations here ensure we get rounded up to the nearest 32 byte boundary
//            let _size := and(add(calldatasize, 0x1f), not(0x1f))
//        // Update the pointer at 0x40 to point at new free memory location so any theoretical allocation doesn't stomp our memory in this call
//            mstore(0x40, add(_calldataMemoryOffset, _size))
//        // Copy method signature and parameters of this call into memory
//            calldatacopy(_calldataMemoryOffset, 0x0, calldatasize)
//        // Call the actual method via delegation
//            let _retval := delegatecall(gas, _target, _calldataMemoryOffset, calldatasize, 0, 0)
//            switch _retval
//            case 0 {
//            // 0 == it threw, so we revert
//                revert(0, 0)
//            } default {
//            // If the call succeeded return the return data from the delegate call
//                let _returndataMemoryOffset := mload(0x40)
//            // Update the pointer at 0x40 again to point at new free memory location so any theoretical allocation doesn't stomp our memory in this call
//                mstore(0x40, add(_returndataMemoryOffset, returndatasize))
//                returndatacopy(_returndataMemoryOffset, 0x0, returndatasize)
//                return (_returndataMemoryOffset, returndatasize)
//            }
//        }
    }
}

```
