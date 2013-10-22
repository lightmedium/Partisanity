class Vote
  include MongoMapper::Document

  one :bill
  one :amendment
  key :category,      String
  key :chamber,       String
  key :congress,      Integer
  key :date,          Time
  key :number,        Integer
  key :question,      String
  key :requires,      String
  key :result,        String
  key :result_text,   String
  key :session,       String
  key :source_url,    String
  key :subject,       String
  key :type,          String
  key :updated_at,    Time
  key :vote_id,       String
  key :votes,         :class_name  => "SessionVote"

  def self.party_positions_map
  <<-MAP
    function() 
    {
      // I couldn't get the aggregation framework to get what I wanted from
      // the GovTrack data in a single query because of the separation of each
      // congressman's vote into Yea, Nay, Aye, No, and Present arrays because
      // of the size limit on collections. This makes the collection much smaller
      // for the high-level chart I want to build, and makes the query a one-step
      // operation.

      // We don't care about procedural and quorum votes.
      if ((this.category != "procedural") || (this.category != "quorum"))
      {
        // Instantiate the result object.
        var o = {};

        // Instantiate the temporary consolidated votes array.
        var votes = [];

        //
        // Define functions for array mapping.
        //
        var mapYesToVote = function(vote, index){vote.response = "y"; return vote;};
        var mapNoToVote = function(vote, index){vote.response = "n"; return vote;}
        var mapPresentToVote = function(vote, index){vote.response = "p"; return vote;}
        
        //
        // Consolidate incoming result arrays into temporary votes array and
        // insert result into vote object for convenience.
        //
        if(this.votes.Yea)
        {
          votes = votes.concat(this.votes.Yea.map(mapYesToVote));
        }

        if(this.votes.Aye)
        {
          votes = votes.concat(this.votes.Aye.map(mapYesToVote));
        }

        if(this.votes.Nay)
        {
          votes = votes.concat(this.votes.Nay.map(mapNoToVote));
        }

        if(this.votes.No)
        {
          votes = votes.concat(this.votes.No.map(mapNoToVote));
        }

        if(this.votes.Present)
        {
          votes = votes.concat(this.votes.Present.map(mapPresentToVote));
        }

        // 
        //  Iterate over all of the votes and build our party counts
        //
        for(var i = 0; i < (votes.length - 1); i++)
        {
          var vote = votes[i];
          var prop = vote.party + vote.response;
          o[prop] ? o[prop] ++ : o[prop] = 1;
        }

        // add the date for querying by the frontend
        o.date = this.date;

        // spit it
        emit(this.vote_id, o)
      }  
    }
  MAP
  end

  def self.party_positions_reduce
  <<-REDUCE
  function(k, v) {
    // does the fact that I'm not doing anything in my reduce method mean I
    // should be using somthing else to accomplish this task? 
    return v;
  }
  REDUCE
  end

  def self.party_positions_map_reduce(opts={out: 'party_positions'})
    Vote.collection.map_reduce(party_positions_map, party_positions_reduce, opts).find()
  end
end