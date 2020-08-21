var Ballot = artifacts.require("./Ballot.sol");

contract("Ballot", ([voter,dele])=> {
  let ballot

  before(async()=>{
  	ballot= await Ballot.deployed()
  })
  describe('deployment',async()=>{
 

		it('deploys successfully',async()=>{
			const address=await ballot.address
			assert.notEqual(address,0x0)
			assert.notEqual(address,'')
			assert.notEqual(address,null)
			assert.notEqual(address,undefined)
		})
	
	})

  /*	describe('initialization',async()=>{
  		let result,voterCount
  		before(async () => {
 			result= await ballot.registrateVoter('on',{from: voter})
      voterCount= await ballot.voterCount()

    	})
  		it('creates a valid voter',async()=>{
  			assert.equal(voterCount,1)
        const event = result.logs[0].args
        assert.equal(event.id.toNumber(),voterCount.toNumber(),'id correcr')
        assert.equal(event.myaddress,voter,'adresa ok')
        assert.equal(event.weight,1,'weight ok')
        assert.equal(event.name,'on','name ok')

  		})
 		
  		
  	})*/
    describe('delegation',async()=>{
      let vot,del,prop,result
      before(async()=>{
       vot= await ballot.registrateVoter('on',{from: voter})
        del= await ballot.registrateVoter('onaj',{from: dele})
        prop= await ballot.addProposal('ugradi krov areni')
        result= await ballot.voteFor('1')
        
      })
      it('delegates voter',async()=>{
        
        const event = result.logs[0].args

        assert.equal(event.name,'ugradi krov areni','weight1 ok')
        assert.equal(event.id,555,' delegat ID relation ok')
        assert.equal(event.voteFor,1,'glasalo za')
        assert.equal(event.totalvote,1,'tatal glasalo')


      })
 
    })
    






});



 
     