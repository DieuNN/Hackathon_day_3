import Animal "animal";
import CustomList "list";
import Debug "mo:base/Debug";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Laptop "custom";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";

actor Main {
    // Challenge 1 : Create two files called custom.mo and main.mo, create your own type inside custom.mo and import it in your main.mo file.
    // In main, create a public function fun that takes no argument but return a value of your custom type.
    public type LaptopType = Laptop.Laptop;
    public func getMyLaptopInfo() : async LaptopType {
      return Laptop.getLaptopInfo();
    };

    //Challenge 2 : Create a new file called animal.mo with at least 2 property (specie of type Text, energy of type Nat),
    // import this type in your main.mo and create a variable that will store an animal.
    var anAnimal : ?Animal.Animal = null;
    
    //Challenge 3 : In animal.mo create a public function called animal_sleep that takes an Animal 
    //and returns the same Animal where the field energy has been increased by 10.
    // Note : As this is a public function of a module, you don't need to make the return type Async !
    // let's check animal.mo file :>

    // Challenge 4 : In main.mo create a public function called create_animal_then_takes_a_break that takes two parameter 
    //: a specie of type Text, an number of energy point of type Nat and returns an animal. 
    //This function will create a new animal based on the parameters passed and then put this animal to sleep before returning it ! 💤
    public func createAnimalThenTakeABreak(specie : Text, energy : Nat)  : async Animal.Animal {
      var animal: Animal.Animal = {
        specie = specie;
        energy = energy;
      };
      animal:= Animal.animalSleep(animal);
      return animal;
    };

    // Challenge 5 : In main.mo, import the type List from the base Library and create a list that stores animal.
    var animals : List.List<Animal.Animal> = List.nil();

    // Challenge 6 : In main.mo : create a function called push_animal that takes an animal as parameter and returns nothing 
    //this function should add this animal to your list created in challenge 5. 
    // Then create a second functionc called get_animals that takes no parameter but 
    ///returns an Array that contains all animals stored in the list.
    public func pushAnimal(animal : Animal.Animal) : async () {
      animals := List.push(animal, animals);
    };

    public func getAnimals() : async [Animal.Animal] {
      return List.toArray(animals);
    };


    // Challenge 11 : Write a function is_anonymous that takes no arguments
    // but returns true is the caller is anonymous and false otherwise.
    public shared({caller}) func isAnonymous() : async Bool {
      return Principal.isAnonymous(caller);
    };

    // Challenge 12 : Create an HashMap called favoriteNumber where the keys are Principal and the value are Nat.
    var hashMap : HashMap.HashMap<Principal, Nat> = HashMap.HashMap<Principal, Nat>(0,Principal.equal, Principal.hash);

    //Challenge 13 : Write two functions :
    // add_favorite_number that takes n of type Nat and stores this value in the HashMap where the key is the principal of the caller.
    // This function has no return value.
    //show_favorite_number that takes no argument and returns n of type ?Nat,
    // n is the favorite number of the person as defined in the previous function or null if the person hasn't registered.
    public shared({caller}) func addFavoriteNumber(n : Nat) : async () {
      hashMap.put(caller, n);
    };

    public shared({caller}) func showFavoriteNumber() : async ?Nat {
      return hashMap.get(caller);
    };

    //Challenge 14 : Rewrite your function add_favorite_number so that if the caller has already registered his favorite number,
    // the value in memory isn't modified. This function will return a text of type Text that indicates 
    //"You've already registered your number" in that case and "You've successfully registered your number" in the other scenario.
    public shared({caller}) func addFavoriteNumberIfNotRegisterYet(n : Nat) : async Result.Result<Text, Text> {
      switch(hashMap.get(caller)) {
        case null {
          hashMap.put(caller, n);
          return#ok("You've successfully registered your number");
        };
        case(?any) {
          return#err("You've already registered your number");
        };
      };
    };


    // Challenge 15 : Write two functions
    // update_favorite_number
    // delete_favorite_number
    public shared({caller}) func updateFavoriteNumber(n : Nat) : async Result.Result<Text, Text> {
      switch(hashMap.get(caller)) {
        case null {
          return#err("You have not register your favorite number yet!");
        };
        case (?any) {
          hashMap.put(caller, any);
          return#ok("Update successfully")
        };
      }
    };

    public shared({caller}) func deleteFavoriteNumber(n : Nat) : async Result.Result<Text, Text> {
      let temp = hashMap.get(caller);
      switch(temp) {
        case null {
          return#err("You have not register your favorite number yet!");
        };
        case (?any) {
          if(temp == n) {
            switch(hashMap.remove(caller)) {
              case null {
                return#err("Something bad happened!");
              };
              case (?any) {
                return#ok("Deleted");
              }
            }
          };
          return#err("That wasn't your number");
        };
      }
    };

    


    // Challenge 16 : Write a function deposit_cycles that allow anyone to deposit cycles into the canister. 
    // This function takes no parameter but returns n of type Nat corresponding to the amount of cycles deposited by the call.
    public func depositCycles() : async Nat {
      let depositAmount = 10000000;
      ExperimentalCycles.add(depositAmount);

      Debug.print(Nat.toText(ExperimentalCycles.balance()));

      return depositAmount;
    };

    // Challenge 17 : Not yet implemented

    // Challenge 18:  Rewrite the counter (of day 1) but this time the counter will be kept accross ugprades. 
    // Also declare a variable of type Nat called versionNumber that will keep track of how many times your canister has been upgraded.
    stable var counter = 0;
    public func increaseCounter() : async () {
      counter+=1;
    };
    public func showCounter() : async Nat {
      return counter + 0;
    };

    // Any code change makes version number update
    stable var versionNumber = 0;
    

    public func showVersionNumber() : async Nat {
      return versionNumber;
    };

    // Challenge 19 : In a new file, copy and paste the functionnalities you've created in challenges 12 to 15.
    // This time the hashmap and all records should be preserved accross upgrades.
    stable var entries : [(Principal, Nat)] = [];
    stable var hashMapSize: Nat = entries.size();

    system func preupgrade() {
      entries := Iter.toArray(hashMap.entries());
    };

    system func postupgrade() {
      versionNumber := versionNumber + 1;
      hashMap:= HashMap.fromIter<Principal, Nat>(entries.vals(), hashMapSize, Principal.equal, Principal.hash );
    };

};
