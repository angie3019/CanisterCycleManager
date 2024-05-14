import CyclesRequester "mo:cycles-manager/CyclesRequester";
import CyclesManager "mo:cycles-manager/CyclesManager";
import { recurringTimer } = "mo:base/Timer";
import Debug "mo:base/Debug";

actor Child{

    // Stable variable holding the cycles requester
  stable var cyclesRequester: ?CyclesRequester.CyclesRequester = null;

  // Initialize the cycles requester
  public func initializeCyclesRequester(
    batteryCanisterPrincipal: Principal,
    topupRule: CyclesRequester.TopupRule,
  ) {
      cyclesRequester := ?CyclesRequester.init({
      batteryCanisterPrincipal;
      topupRule
    });
  };

 // Local helper function to check if balance is low 
  func requestTopupIfLow(): async* CyclesManager.TransferCyclesResult {
    Debug.print("Checking Balance: ");
    switch(cyclesRequester) {
      case null #err(#other("CyclesRequester not initialized"));
      case (?requester) await* CyclesRequester.requestTopupIfBelowThreshold(requester);
    }
  }; 
 
 // Set recurring Timer after every minute to check balance and request Top-up if below Threshold
  let balanceChecker = recurringTimer(#seconds (60), requestTopupIfLow);

}