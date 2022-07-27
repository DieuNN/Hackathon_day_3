import List "mo:base/List";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
module {
    // Challenge 7 : Write a function is_null that takes l of type List<T> and returns a boolean indicating if the list is null .
    // Tips : Try using a switch/case.
    public func isNull(list :List.List<Nat>) : Bool {
        switch(list) {
            case null {
                true;
            };
            case _ {
                false;
            }
        };
    };

   // Challenge 8 : Write a function last that takes l of type List<T> and returns the optional last element of this list.
   public func last<T>(l : List.List<T>) : ?T {
    switch l {
      case null { null };
      case (?(x, null)) { ?x };
      case (?(_, t)) { last<T>(t) };
    }
  };

   // Challenge 9 : Write a function size that takes l of type List<T> and returns a Nat indicating the size of this list.
   public func size<T>(l : List.List<T>) : Nat {
    func rec(l : List.List<T>, n : Nat) : Nat {
      switch l {
        case null { n };
        case (?(_, t)) { rec(t, n + 1) };
      }
    };
    rec(l,0)
  };

   // Challenge 10 : Write a function get that takes two arguments : l of type List<T> and n of type Nat 
   //this function should return the optional value at rank n in the list.
   public func get<T>(l : List.List<T>, n : Nat) : ?T {
    switch (n, l) {
      case (_, null) { null };
      case (0, (?(h, t))) { ?h };
      case (_, (?(_, t))) { get<T>(t, n - 1) };
    }
  };

    


   


};