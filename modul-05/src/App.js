import { ethers } from 'ethers';
import React, { useEffect, useState } from 'react';
import './App.css';

const contractAddress = '0xe4EE33F790f790950E0064E0E5aC474BE36d577F';
const provider = new ethers.providers.JsonRpcProvider('https://opt-sepolia.g.alchemy.com/v2/XkzV0sqoPLCjYKdk3n1F8RxPRxmOO81c');
const abi = [
  "function calculatePrizesProjection() view returns (uint256)",
  "function makeMove(uint256 _move) public"
];

function App() {
  const [balance, setBalance] = useState(null);
  const [calculateResult, setCalculateResult] = useState(null);
  const [moveResult, setMoveResult] = useState(null);
  const [signer, setSigner] = useState(null);
  const [providerState, setProviderState] = useState(null);

  useEffect(() => {
    const initSigner = async () => {
      try {
        if (window.ethereum) {
          const permissions = await window.ethereum.request({ method: 'wallet_getPermissions' });
          const hasAccountsPermission = permissions.some(
            (perm) => perm.parentCapability === 'eth_accounts'
          );

          if (!hasAccountsPermission) {
            await window.ethereum.request({ method: 'eth_requestAccounts' });
          }

          const web3Provider = new ethers.providers.Web3Provider(window.ethereum);
          setProviderState(web3Provider);
          setSigner(web3Provider.getSigner());
        } else {
          console.error('No Ethereum wallet detected');
        }
      } catch (error) {
        if (error.code === -32002) {
          console.error('Please respond to the MetaMask prompt before trying again.');
        } else {
          console.error('Error initializing signer:', error);
        }
      }
    };

    initSigner();
  }, []);

  const getBalance = async () => {
    try {
      const balance = await provider.getBalance(contractAddress);
      setBalance(ethers.utils.formatEther(balance));
    } catch (error) {
      console.error('Error fetching balance:', error);
    }
  };

  const calculatePrizesProjection = async () => {
    try {
      const contract = new ethers.Contract(contractAddress, abi, provider);
      const result = await contract.calculatePrizesProjection();
      setCalculateResult(result.toString());
    } catch (error) {
      console.error('Error executing calculatePrizesProjection:', error);
    }
  };

  const makeMove = async () => {
    try {
      if (!signer) {
        console.error('Signer not initialized');
        setMoveResult('Signer not initialized.');
        return;
      }

      const contract = new ethers.Contract(contractAddress, abi, signer);
      const tx = await contract.makeMove(1); // Example move value
      await tx.wait();
      setMoveResult('Move executed successfully!');
    } catch (error) {
      console.error('Error executing makeMove:', error);
      setMoveResult(`Move execution failed: ${error.message}`);
    }
  };

  return (
    <div className="App">
      <h1>Smart Contract Interaction</h1>
      <button onClick={getBalance}>Get Contract Balance</button>
      {balance && (
        <div>
          <h2>Balance:</h2>
          <p>{balance} ETH</p>
        </div>
      )}

      <button onClick={calculatePrizesProjection}>Calculate Prizes Projection</button>
      {calculateResult && (
        <div>
          <h2>Prizes Projection Result:</h2>
          <p>{calculateResult}</p>
        </div>
      )}

      <button onClick={makeMove}>Make Move</button>
      {moveResult && (
        <div>
          <h2>Move Result:</h2>
          <p>{moveResult}</p>
        </div>
      )}
    </div>
  );
}

export default App;
