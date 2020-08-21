import React, { Component } from 'react';
import Web3 from 'web3'
import logo from '../logo.png';
import './App.css';
import Ballot from '../abis/Ballot.json'
import Navbar from './Navbar'
import Main from './Main'

class App extends Component {
   

  async componentWillMount() {
    await this.loadWeb3()
    await this.loadBlockchainData()
  }

  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      await window.ethereum.enable()
    }
    else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  }

  async loadBlockchainData() {
    const web3 = window.web3
    // Load account
    const accounts = await web3.eth.getAccounts()
    this.setState({ account: accounts[0] })
    const networkId = await web3.eth.net.getId()
    const networkData = Ballot.networks[networkId]
    if(networkData) {
      const ballot = web3.eth.Contract(Ballot.abi, networkData.address)
      this.setState({ ballot })
      const proposalCount = await ballot.methods.proposalCount().call()
      this.setState({ proposalCount })
      const voterCount = await ballot.methods.voterCount().call()
      this.setState({ voterCount })

      // Load proposal
      for (var i = 1; i <= proposalCount; i++) {
        const proposal = await ballot.methods.proposals(i).call()
        this.setState({
          proposals: [...this.state.proposals, proposal]
        })
      }

      for(var i=1;i<=voterCount;i++){
        const voter = await ballot.methods.voters(i).call()
        this.setState({
          voters:[...this.state.voters,voter]
        })
      }
      this.setState({loading:false})

    } else {
      window.alert('Ballot contract not deployed to detected network.')
    }
  }

  constructor(props) {
    super(props)
    this.state = {
      account: '',
      proposalCount: 0,
      voterCount: 0,
      proposals: [],
      voters:[],

      loading: true
    }

    this.addProposal = this.addProposal.bind(this)
    this.registrateVoter=this.registrateVoter.bind(this)
    this.delegateVote=this.delegateVote.bind(this)
    this.cancleDelegation=this.cancleDelegation.bind(this)
    this.voteFor = this.voteFor.bind(this)
    this.voteAgainst = this.voteAgainst.bind(this)
  }

  addProposal(name){
     this.setState({loading: true})
    this.state.ballot.methods.addProposal(name).send({ from: this.state.account })
    .once('receipt',(receipt)=>{
      this.setState({loading: false})
    })

  }
  registrateVoter(voterName){
    this.setState({loading:true})
    this.state.ballot.methods.registrateVoter(voterName).send({ from: this.state.account })
    .once('receipt',(receipt)=>{
      this.setState({loading: false})
    })
  }
  delegateVote(delegate){
    this.setState({loading:true})
    this.state.ballot.methods.delegateVote(delegate).send({ from: this.state.account })
    .once('receipt',(receipt)=>{
      this.setState({loading: false})
    })

  }
  cancleDelegation(){
    this.setState({loading:true})
    this.state.ballot.methods.cancleDelegation().send({ from: this.state.account })
    .once('receipt',(receipt)=>{
      this.setState({loading: false})
    })


  }
  voteFor(proposalId){

    this.setState({loading: true})
    this.state.ballot.methods.voteFor(proposalId).send({ from: this.state.account })
    .once('receipt',(receipt)=>{
      this.setState({loading: false})

    })
    

  
  }
  voteAgainst(proposalId){

    this.setState({loading: true})
    this.state.ballot.methods.voteAgainst(proposalId).send({ from: this.state.account })
    .once('receipt',(receipt)=>{
      this.setState({loading: false})

    })
    

  
  }

  render() {
    return (
      <div>
        <Navbar account={this.state.account} />
        <div className="container-fluid mt-5">
          <div className="row">
            <main role="main" className="col-lg-12 d-flex">
              { this.state.loading
                ? <div id="loader" className="text-center"><p className="text-center">Loading...</p></div>
                : <Main
                  voters={this.state.voters}
                  proposals={this.state.proposals}
               
                  addProposal={this.addProposal}
                  registrateVoter={this.registrateVoter}
                  voteFor={this.voteFor} 
                  voteAgainst={this.voteAgainst}
                  delegateVote={this.delegateVote}
                  cancleDelegation={this.cancleDelegation}
                    />
                  
                  
              }
            </main>

          </div>
        </div>
      </div>
    );
  }
}

export default App;

