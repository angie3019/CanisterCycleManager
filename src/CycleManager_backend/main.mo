import Debug "mo:base/Debug";
import Cycles "mo:base/ExperimentalCycles";
import Principal "mo:base/Principal";
import { recurringTimer } = "mo:base/Timer";

actor Example {

//Interface to implement Management Canister to retrieve freezing_threshold
let IC = actor "aaaaa-aa" : actor {
      
// Canister_Status api to retrieve important info regarding canister passed as an argument
      canister_status : shared { canister_id : Principal} -> async {
      status : { #stopped; #stopping; #running };
      memory_size : Nat;
      cycles : Nat;
      module_hash : ?[Nat8];
      freezing_threshold :Nat ;
    };
};

 
// Function to check freezing threshold of a canister
public  func checkThresholdAndSetTimer() : async() {
      Debug.print("Main balance: " # debug_show(Cycles.balance()));
      let canisterId : Principal  = Principal.fromActor(Example);
      let cStatus =  await IC.canister_status({canister_id = canisterId});
      Debug.print("status " # debug_show(cStatus.freezing_threshold));

  };

// Utility function to test Timer
  func checkBalance() :  async() {
      Debug.print("Main balance: " # debug_show(Cycles.balance()));
  };

  // Set recurring Timer after every minute to run utility function CheckBalance()
  let daily = recurringTimer(#seconds (60), checkBalance);
  
}
