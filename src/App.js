import { useEffect, useState } from "react";
import web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";

import "./App.css";
import { loadContract } from "./utils/load-contract";

function App() {
  const [web3Api, setweb3Api] = useState({
    provider: null,
    web3: null,
    contract: null,
  });

  const [account, setAccount] = useState(null);

  const [balance, setBalance] = useState("Loading..");

  useEffect(() => {
    const loadProvider = async () => {
      // with metamask we have an access
      // to window.ethereum and window.web3

      // metamask injects a global API into website
      // This API allows websites to request users, accounts, read data
      // to blockchain, sign message and transaction

      // console.log(window.web3);
      // console.log(window.ethereum);
      let provider = await detectEthereumProvider();
      let contract = null;
      if (provider) {
        // provider.request({ method: "eth_requestAccounts" });

        const contract = await loadContract("MyContract", provider);
        console.log(contract);

        setweb3Api({
          web3: new web3(provider),
          provider: provider,
          contract: contract,
        });
        console.log("Ethereum successfully detected!");
      } else {
        console.log("Please install metamask");
      }

      if (window.ethereum) {
        provider = window.ethereum;

        try {
          await provider.request({ method: "eth_requestAccounts" });
        } catch {
          console.log("User denied account access!!");
        }
      } else if (window.web3) {
        provider = window.web3.currentProvider;
      } else if (!process.env.production) {
        provider = new web3.providers.HttpProvider("http://localhost:7545");
      }

      contract = await loadContract("MyContract", provider);
      console.log(contract);

      setweb3Api({
        web3: new web3(provider),
        provider: provider,
        contract: contract,
      });
    };

    loadProvider();
  }, []);

  useEffect(() => {
    const getAccount = async () => {
      const accounts = await web3Api.web3.eth.getAccounts();
      setAccount(accounts[0]);
    };

    web3Api.web3 && getAccount();
  }, [web3Api.web3]);

  //Load Balance

  useEffect(() => {
    const loadBalance = async () => {
      const { contract, web3 } = web3Api;
      const balance = await web3.eth.getBalance(contract.address);
      setBalance(web3.utils.fromWei(balance, "ether"));
    };

    web3Api.contract && loadBalance();
  }, [web3Api.contract]);

  console.log(web3Api.web3);
  console.log(account);
  console.log(balance);

  //Payment / Add Funds

  const addFunds = async () => {
    const { contract, web3 } = web3Api;
    await contract.addFunds({
      from: account,
      value: web3.utils.toWei("0.5", "ether"),
    });
  };

  const withdraw = async () => {
    const { contract, web3 } = web3Api;
    await contract.withDraw(web3.utils.toWei("0.01", "ether"), {
      from: account,
    });
  };

  return (
    <div className="App">
      <div className="card">
        <header className="card-header">
          <p className="card-header-title">DAPP MART</p>
          <button className="card-header-icon" aria-label="more options">
            <span className="icon">
              <i className="fas fa-angle-down" aria-hidden="true"></i>
            </span>
          </button>
        </header>
      </div>
      <div className="app-wrapper">
        <div className="app">
          <span>
            <strong>Account : </strong>
          </span>
          <h1>{account ? account : "Not connected"}</h1>
          <div className="balance-view is-size-2">
            Current Balance : <strong>{balance}</strong> ETH
          </div>

          <button className="button is-link mr-2" onClick={addFunds}>
            Pay 0.5 Eth
          </button>
          <button className="button is-primary" onClick={withdraw}>
            Withdraw
          </button>
        </div>
      </div>
    </div>
  );
}

export default App;
