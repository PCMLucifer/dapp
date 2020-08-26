pragma solidity >=0.4.22 <0.7.0;

/** 
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */
contract Ballot {
   
    struct Voter {
         //ID used for mapping
        uint id;
        
        //address of the voter. used to locate the voter during voting
        address myaddress;
        
        // weight of your vote, seach delegation to a certain voter increises weight by 1
        uint weight; 
        
        // name of the voter
        string name;
        
        //ID of the person we delegate our vote
        uint delegate;
        
        //list of peopel who delegated votes to us
        uint[] delegatorList;

    }
 

    struct Proposal {
    // id of the proposal used for mapping
        uint id;
        
        //list of voter id's who already voted
        uint[] voterList;
        
        //name of the proposal
        string name;   
       
       //votes in davor of the proposal
        uint voteFor; 
        
        //votes agaisnt the proposal
        uint voteAgainst;
        
        //total number of votes
        uint totalvote;
    }
    event proposaladded(
        uint id,
        uint[] voterList,
        string name,   // short name (up to 32 bytes)
        uint voteFor, // number of accumulated votes
        uint voteAgainst,
        uint totalvote
        );
    

    uint public voterCount=0;

    uint public proposalCount=0;


    mapping(uint => Voter) public voters;

    mapping(uint=>Proposal) public proposals;



    constructor() public {

       
    }
    function registrateVoter (string memory _name) public{

        for(uint i=0;i<=voterCount;i++){
            Voter storage test=voters[i];
            require(test.myaddress!=msg.sender,"voter already registerated");
        }
        voterCount++;
        voters[voterCount]=Voter(voterCount,msg.sender, 1,_name,0,new uint[](0));

    }
    function addProposal (string memory _name) public {
        proposalCount ++;
        proposals[proposalCount] = Proposal(proposalCount,new uint[](0), _name, 0,0,0);
       
    }
    
    
    function delegateVote(uint  _to) public {
        address delegator=msg.sender;
        uint sender=0;
        uint wt=voters[_to].weight;
        wt++;        
        for(uint i=0;i<=voterCount;i++){
 
            if(voters[i].myaddress==delegator){
                sender=i;
                break;
            }else if(i==voterCount && voters[i].myaddress!=delegator){
                require (voters[i].myaddress==delegator,"unregistrated voter");    
            }
        }

        require(voters[_to].id==_to,"invalid id");
         require (voters[_to].weight!=0,"can't delegate to someone who delegate his vote");    
          require (voters[_to].id!=sender,"can't delegate to yourself");    
         require (voters[sender].weight==1,"you have either delegated your vote or have votes delegated on yourself");    
        
        voters[sender].delegate = _to;
        voters[sender].weight=0;
        

        voters[_to].weight=wt;
        voters[_to].delegatorList.push(sender);

        
       
    }
    function cancleDelegation () public{
        address delegator=msg.sender;
        uint sender=0;
        uint del=voters[sender].delegate;

        for(uint i=0;i<=voterCount;i++){
            if(voters[i].myaddress==delegator){
                sender=i;
                break;
            }else if(i==voterCount && voters[i].myaddress!=delegator){
                require (voters[i].myaddress==delegator,"unregistrated voter");    
            }
        }
        require (voters[sender].delegate!=0,"you do not have a delegate"); 

        voters[del].weight--;
        for(uint i;i<=voters[del].delegatorList.length;i++){
            if(voters[del].delegatorList[i]==sender){
               voters[del].delegatorList[i]=0;
            }
        }

        voters[sender].delegate = 0;
        voters[sender].weight=1;

     
     
    }
    

  
    

    function voteFor(uint  _proposalId) public {
        address voter=msg.sender;
        uint sender=0;
        

        for(uint i=0;i<=voterCount;i++){

            if(voters[i].myaddress==voter){
                sender=i;
                break;
            }else if(i==voterCount && voters[i].myaddress!=voter){
                require (voters[i].myaddress==voter,"unregistrated voter");    
            }
        }

        require (voters[sender].delegate==0,"You have delegated  your vote, please cancle your delegation in ordewr to vote");
        for(uint i=0;i<=proposals[_proposalId].voterList.length;i++){

            require (proposals[_proposalId].voterList[i]!=sender, "your vote has been registrated");
            
        }
        proposals[_proposalId].voteFor++;
        proposals[_proposalId].totalvote++;

        proposals[_proposalId].voterList.push(sender);
        for(uint i=0;i<=voters[sender].delegatorList.length;i++){
            proposals[_proposalId].voterList.push(voters[sender].delegatorList[i]);


        emit proposaladded(proposals[_proposalId].id,proposals[_proposalId].voterList,proposals[_proposalId].name,proposals[_proposalId].voteFor,proposals[_proposalId].voteAgainst,proposals[_proposalId].totalvote);

        }


    }

    function voteAgainst(uint  _proposalId) public {
       address voter=msg.sender;
        uint sender=0;
        

        for(uint i=0;i<=voterCount;i++){

            if(voters[i].myaddress==voter){
                sender=i;
                break;
            }else if(i==voterCount && voters[i].myaddress!=voter){
                require (voters[i].myaddress==voter,"unregistrated voter");    
            }
        }

        require (voters[sender].delegate==0,"You have delegated  your vote, please cancle your delegation in ordewr to vote");
        for(uint i=0;i<=proposals[_proposalId].voterList.length;i++){

            require (proposals[_proposalId].voterList[i]!=sender, "your vote has been registrated");
            
        }
        proposals[_proposalId].voteAgainst++;
        proposals[_proposalId].totalvote++;

        proposals[_proposalId].voterList.push(sender);
        for(uint i=0;i<=voters[sender].delegatorList.length;i++){
            proposals[_proposalId].voterList.push(voters[sender].delegatorList[i]);
        }

    
    }
}
