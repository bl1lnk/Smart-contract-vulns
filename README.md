# Smart-contract-vulns

Below is the function from the ERC20 contract which had the initial vulnerability.  Also, a link to view the code for yourself on etherscan.  Just do ctrl+f search for the batch transfer function on the contract page.

https://etherscan.io/address/0xc5d105e63711398af9bbff092d4b6769c82f793d#code

Reviewing the Real Attack Transaction

Now let’s take a look at an actual transaction that caused this overflow attack.

Below is the transaction from the overflow attack.  Also, a link to view the transaction for yourself on etherscan.  Just click the “click to see more” button and check out the “input data” section.

https://etherscan.io/tx/0xad89ff16fd1ebe3a0a7cf4ed282302c06626c1af33221ebe0d3a470aba4a660f


Function: batchTransfer(address[] _receivers, uint256 _value)

MethodID: 0x83f12fec

[0]:  0000000000000000000000000000000000000000000000000000000000000040

[1]:  8000000000000000000000000000000000000000000000000000000000000000

[2]:  0000000000000000000000000000000000000000000000000000000000000002

[3]:  000000000000000000000000b4d30cac5124b46c2df0cf3e3e1be05f42119033

[4]:  0000000000000000000000000e823ffe018727585eaf5bc769fa80472f76c3d7

 

If you reviewed the transaction on chain you would see the above transaction data.

Let’s go into a little detail as to what the transaction values are and how they were derived. This will help in understanding what is going on with this attack.

The data in the transaction can be broken down as the following

    ü  A 4byte MethodID

    ü  Five 32-byte values

The 4-byte MethodID which precedes the function parameters is the first 4 bytes of a sha3 hash of the batchTransfer method declaration minus the variable names and spaces. We can derive this sha3 value from the transaction by using the web3 utility functions and a substring of the sha3 output.

You can try this out with the following node commands.

$ npm install web3

$ node

> const web3 = require('web3')

> web3.utils.sha3("batchTransfer(address[],uint256)").substring(0,10)

'0x83f12fec'


The 5 parameters following the MethodID are defined as follows:

    [0] Offset to the _recievers Array, length value: 40Hex or 64 bytes (2x32 = 64bytes to the Array length held at [2])

    [1] This is the actual _value which is being sent that when multiplied causes an overflow. (A very large number)

    [2] This is the size of the _recievers array sent to batch transfer in this case 2 addresses

    [3] This is the first address from the _recievers array used in the batch transfer.

    [4] This is the second address from the _recievers array used in the batch transfer.
