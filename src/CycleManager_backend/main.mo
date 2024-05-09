import Debug "mo:base/Debug";
import Cycles "mo:base/ExperimentalCycles";
import Principal "mo:base/Principal";
import { recurringTimer } = "mo:base/Timer";

actor Example {


/*
    type canister_status_response = {
    status : {#stopped; #stopping; #running};
    memory_size : Nat;
    cycles : Nat;
    freezing_threshold:Nat;
  };*/

 
  //let ic = actor ("aaaaa-aa") : actor{
        //canister_status :  query ( Principal) -> async canister_status_response;

      //canister_status : query (Principal) -> async canister_status_response;
      // start_canister : shared {canister_id : canister_id} -> async ();
     //startCanister :(Principal) -> async ()  ;
//};
let IC = actor "aaaaa-aa" : actor {
      

    canister_status : shared { canister_id : Principal} -> async {
      status : { #stopped; #stopping; #running };
      memory_size : Nat;
      cycles : Nat;
      module_hash : ?[Nat8];
      freezing_threshold :Nat ;
    };
};

  public query func greet(name : Text) : async Text {
    return "Hello there, " # name # "!";
  };

  public  func chk() : async() {
      Debug.print("Main balance: " # debug_show(Cycles.balance()));
      let canisterId : Principal  = Principal.fromActor(Example);
      let cStatus =  await IC.canister_status({canister_id = canisterId});
      Debug.print("status " # debug_show(cStatus.freezing_threshold));

  };

          func checkBalance() :  async() {
          Debug.print("Main balance: " # debug_show(Cycles.balance()));
  };




  let daily = recurringTimer(#seconds (60), checkBalance);
  
}
