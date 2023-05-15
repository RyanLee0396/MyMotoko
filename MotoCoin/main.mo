import Account "account";
import TrieMap "mo:base/TrieMap";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import Bool "mo:base/Bool";
import Text "mo:base/Text";
import Option "mo:base/Option";
actor MotoCoin {

    type Account = Account.Account;

    let ledger = TrieMap.TrieMap<Account, Nat>(Account.accountsEqual, Account.accountsHash);

    public query func name():async Text{
        return "MotoCoin";

    };

    public query func symbol():async Text{
        return "MOC";

    };

    public shared query func totalSupply():async Nat{
        var supply:Nat = 0;
        for(i in ledger.vals()){
            supply := supply + i;
        };

        return supply;
    };

    public shared query func balanceOf(account:Account):async Nat{
        let balance:?Nat= ledger.get(account);
        switch(balance){
            case(null){
                return 0;
            };
            case(?balance){
                return balance;
            };
        };
    };

    public shared func transfer(from:Account,to:Account,amount:Nat):async Result.Result<(),Text>{
         let sender:Nat=await balanceOf(from);
         if (sender < amount) return #err("Insufficient funds");
         let receiver:Nat=await balanceOf(to);
            ledger.put(from, sender - amount);
            ledger.put(to, receiver + amount);
            return #ok(());
        

    };

    let studentpids : actor {
        getAllStudentsPrincipal : shared () -> async [Principal];
      } = actor("rww3b-zqaaa-aaaam-abioa-cai") ;



    public shared func airdrop(): async Result.Result<(), Text>{

    try{
       let allpids: [Principal] = await studentpids.getAllStudentsPrincipal();
     
      for(i in allpids.vals()){
      
        let account: Account ={
          owner = i;
          subaccount = null;
        };
        let coinsnow = Option.get(ledger.get(account),0);
        ledger.put(account, (coinsnow + 100));
      };
      #ok();
    }catch(Error)#err("An error occured");
  };







};