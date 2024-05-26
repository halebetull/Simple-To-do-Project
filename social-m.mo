import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Principal "mo:base/Principal";

actor SocialMedia {

  type Post = {
    author : Principal;
    content : Text;
    timestamp : Time.Time;
  };

  func natHash(n : Nat) : Hash.Hash {
    Text.hash(Nat.toText(n));
  };

  var posts = Map.HashMap<Nat, Post>(0, Nat.equal, natHash); 
  var nextId : Nat = 0; 

  
  public query func getPosts() : async [(Nat, Post)] {
    
    Iter.toArray(posts.entries()); 
  };

  
  public shared (msg) func addPost(content : Text) : async Text {
    
    let id = nextId; 
    posts.put(id, { author = msg.caller; content = content; timestamp = Time.now() }); 
    nextId += 1; 
    "Gönderi başarıyla eklendi. Gönderi ID'si: " # Nat.toText(id); 
  };

  
  public query func viewPost(id : Nat) : async ?Post {
    
    posts.get(id); 
  };

  
  public func clearPosts() : async () {
   
    for (key : Nat in posts.keys()) {
      
      ignore posts.remove(key); 
    };
  };

 
  public shared (msg) func editPost(id : Nat, newContent : Text) : async Bool {
   
    switch (posts.get(id)) {
    
      case (?post) {
       
        if (post.author == msg.caller) {
          
          posts.put(id, { author = msg.caller; content = newContent; timestamp = post.timestamp }); 
          return true; 
        } else {
          return false; 
        };
      };
      case null {
        
        return false; 
      };
    };
  };

};