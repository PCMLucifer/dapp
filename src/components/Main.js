import React, { Component } from 'react';

class Main extends Component {


  render() {

    return (
      <div id="content">
        <h1>Add Proposal</h1>

        <form onSubmit={(event) => {
          event.preventDefault()
          const name = this.proposal.value
          this.props.addProposal(name)
        }}>

          <div className="form-group mr-sm-2">
            <input
              id="proposal"
              type="text"
              ref={(input) => { this.proposal = input }}
              className="form-control"
              placeholder="Proposal"
              required />
             
          </div>

          <button type="submit" className="btn btn-primary">Add Proposal</button>

        </form>
        <p>&nbsp;</p>
        <h2>Vote</h2>
     
        <table className="table">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col"> Proposed: </th>
              <th scope="col">  </th>
              <th scope="col">  </th>
              <th scope="col">  </th>
            </tr>
          </thead>
          <tbody id="proposalList">
            { this.props.proposals.map((proposal, key) => {
              return(
                <tr key={key}>
                  <th scope="row">{proposal.id.toString()}</th>
                  <td>{proposal.name}</td>
                  
                  <td>For {this.props.proposals.voteFor} </td>
                  <td>
                    
                    <button
                          name={proposal.id}
                          
                          onClick={(event) => {
                            this.props.voteFor(event.target.name)
                          
                          }}
                        >
                          Vote for
                        </button>
                    </td>
                   
                    <td>   Agaisnt  {this.props.proposals.voteAgainst}  </td>
                    <td>

                    <button
                          name={proposal.id}
                          
                          onClick={(event) => {
                            this.props.voteAgainst(event.target.name)
                     
                          }}
                        >
                          Vote Against
                        </button>
                        
                    </td>
                    
                
                </tr>
              );
            })}
          </tbody>
        </table>


         
          
        
          
        <form onSubmit={(event) => {
          event.preventDefault()
          const name = this.voter.value
          this.props.registrateVoter(name)
        }}>

        <h1>Register voter</h1>

          <div className="form-group mr-sm-2">
            <input
              id="voter"
              type="text"
              ref={(input) => { this.voter = input }}
              className="form-control"
              placeholder="Insert name"
              required />
             
          </div>

          <button type="submit" className="btn btn-primary">registrate Voter </button>
        </form>
      
    
        <table className="table">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col"> Voter: </th>
              <th scope="col">  </th>
              <th scope="col">  </th>
              <th scope="col">  </th>
            </tr>
          </thead>
          
          
           <tbody id="voterList">
            { this.props.voters.map((voter, key) => {
              return(
                <tr key={key}>
                  <th scope="row">{voter.id.toString()}</th>
                  <td>{voter.name}</td>
  
                  <td>

                    <button
                          name={voter.id}
                          
                          onClick={(event) => {
                            this.props.delegateVote(event.target.name)
                            // triba adresa ne name
                            }
                        }
                        >
                          Delegate your vote to this person
                        </button>
                                             
                    </td>
                    
                </tr>
              );
            })}

             { this.props.voters.map((voter, key) => {
              return(
                <tr key={key}>

  
                  <td>
                  { voter.delegate!=0
                    ?<button

                          
                          onClick={(event) => {
                            this.props.cancleDelegation()
                            // triba adresa ne name
                            }
                        }
                        >

                        cancle delegation
                        </button>
                        : null
                      }
                    </td>
                    
                </tr>
              );
            })}


            
          </tbody>
        </table>


      </div>
    );
  }
}

export default Main;
