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
    
    // counters of the total numbers of voters adn probpsals
    uint public voterCount=0;
    uint public proposalCount=0;

    //voter and proposal mapping
    mapping(uint => Voter) public voters;
    mapping(uint=>Proposal) public proposals;



    constructor() public {

       
    }

    function registrateVoter (string memory _name) public{
        //cheking if the person calling the function has already registrated as a voter
        for(uint i=0;i<=voterCount;i++){
            Voter storage test=voters[i];
            require(test.myaddress!=msg.sender,"_voter already registerated");
        }

        //creation of a new voter
        voterCount++;
        voters[voterCount]=Voter(voterCount,msg.sender, 1,_name,0,new uint[](0));

    }
    function addProposal (string memory _name) public {
        proposalCount ++;
        proposals[proposalCount] = Proposal(proposalCount,new uint[](0), _name, 0,0,0);
       
    }
    
    
    function delegateVote(uint  _to) public {
        address _delegator=msg.sender;
        uint _sender=0;
        uint _wt=voters[_to].weight;
        _wt++;

        //cheking if the person calling the function is a registrated voter        
        for(uint i=0;i<=voterCount;i++){
 
            if(voters[i].myaddress==_delegator){
                _sender=i; //saving the index of a the voter
                break;
            }else if(i==voterCount && voters[i].myaddress!=_delegator){
                require (voters[i].myaddress==_delegator,"unregistrated _voter");    
            }
        }

        /*cheking if the ID of a voter we're delegating to is valid
            if the voter hasn't delegated their vote
            if this is an attempt of self delegation
            and if the delegator has delegated his vote already or is himself a delegator
        */
        require(voters[_to].id==_to,"invalid id");
         require (voters[_to].weight!=0,"can't delegate to someone who delegate his vote");    
          require (voters[_to].id!=_sender,"can't delegate to yourself");    
         require (voters[_sender].weight==1,"you have either delegated your vote or have votes delegated on yourself");    
        
        voters[_sender].delegate = _to;
        voters[_sender].weight=0;
        

        voters[_to].weight=_wt;
        voters[_to].delegatorList.push(_sender);

        
       
    }
    function cancleDelegation () public{

        uint _sender=0;
        uint _tmp=0;

        //checking the validity of the sender as a registrated voter
        for(uint i=0;i<=voterCount;i++){
            if(voters[i].myaddress==msg.sender){
                _sender=i; //saving the senders ID
                break;
            }else if(i==voterCount && voters[i].myaddress!=msg.sender){
                require (voters[i].myaddress==msg.sender,"unregistrated _voter");    
            }
        }
        //checking if the sender actualyl ahs a delegate
        require (voters[_sender].delegate!=0,"you do not have a delegate"); 
        uint _del=voters[_sender].delegate;

        voters[_del].weight--;

        /*deletion of the senders ID from the delegates delegator list
            nested loop was deemed necessery to eliminate empty palces in the delegator lsit
        */
        for(uint j=0;j<voters[_del].delegatorList.length;j++){
            if(voters[_del].delegatorList[j]!=_sender){
               delete voters[_del].delegatorList[j];
               _tmp=j;
               while(_tmp<voters[_del].delegatorList.length){
                   if(_tmp+1==voters[_del].delegatorList.length){
                       delete voters[_del].delegatorList[_tmp];
                   }else{
                       voters[_del].delegatorList[_tmp]=voters[_del].delegatorList[_tmp+1];
                   }
               }
            }
        }

        voters[_sender].delegate = 0;
        voters[_sender].weight=1;

     
     
    }
    

  
    

    function voteFor(uint  _proposalId) public {
        address _voter=msg.sender;
        uint _sender=0;
        
        //checking validity and saving the voters index
        for(uint i=0;i<=voterCount;i++){

            if(voters[i].myaddress==_voter){
                _sender=i;
                break;
            }else if(i==voterCount && voters[i].myaddress!=_voter){
                require (voters[i].myaddress==_voter,"unregistrated _voter");    
            }
        }
        /*requirement for the voter not to have a delegate 
        or have been registrated as voted on the proposition*/
        require (voters[_sender].delegate==0,"You have delegated  your vote, please cancle your delegation in ordewr to vote");
         for(uint j=0;j<proposals[_proposalId].voterList.length;j++){

            require (proposals[_proposalId].voterList[j]!=_sender, "your vote has been registrated");
            
        }
        proposals[_proposalId].voteFor++;
        proposals[_proposalId].totalvote++;
        //adding the voter and his potential delegators to the list of peopel who voted on the proposition
        proposals[_proposalId].voterList.push(_sender);
        for(uint n=0;n<voters[_sender].delegatorList.length;n++){

            proposals[_proposalId].voterList.push(voters[_sender].delegatorList[n]);


        emit proposaladded(proposals[_proposalId].id,proposals[_proposalId].voterList,proposals[_proposalId].name,proposals[_proposalId].voteFor,proposals[_proposalId].voteAgainst,proposals[_proposalId].totalvote);

        }


    }

    function voteAgainst(uint _proposalId) public {
       address _voter=msg.sender;
        uint _sender=0;
        

        for(uint i=0;i<=voterCount;i++){

            if(voters[i].myaddress==_voter){
                _sender=i;
                break;
            }else if(i==voterCount && voters[i].myaddress!=_voter){
                require (voters[i].myaddress==_voter,"unregistrated _voter");    
            }
        }

        require (voters[_sender].delegate==0,"You have delegated  your vote, please cancle your delegation in ordewr to vote");
        for(uint j=0;j<proposals[_proposalId].voterList.length;j++){

            require (proposals[_proposalId].voterList[j]!=_sender, "your vote has been registrated");
            
        }
        proposals[_proposalId].voteAgainst++;
        proposals[_proposalId].totalvote++;

        proposals[_proposalId].voterList.push(_sender);
        for(uint n=0;n<voters[_sender].delegatorList.length;n++){
            proposals[_proposalId].voterList.push(voters[_sender].delegatorList[n]);
        }

    
    }
}
