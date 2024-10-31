// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

// This is a testing project

// 1️⃣ Create a Twitter Contract 
// 2️⃣ Create a mapping between user and tweet 
// 3️⃣ Add function to create a tweet and save it in mapping
// 4️⃣ Create a function to get Tweet 
// 5️⃣ Add array of tweets 

contract Twitter {

    uint16 MAX_TWEET_LENGTH = 280;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner!");
        _;
    }

    struct Tweet {
    address author;
    string content;
    uint timestamp;
    uint likes;
    uint id;
    }

    Tweet public myTweets;

    mapping (address => Tweet[]) public tweets;

    event TweetCreated(address author, string tweet, uint timestamp, uint tweetId);
    event TweetLike(address author, address liker, uint tweetId, uint newLikeCount);
    event TweetUnike(address author, address unliker, uint tweetId, uint newLikeCount);

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "The tweet is too long!");

        Tweet memory newTweet = Tweet ({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });
        tweets[msg.sender].push(newTweet);

        emit TweetCreated(newTweet.author, newTweet.content, newTweet.timestamp, newTweet.id);
    }

    function getTweets(address _owner, uint _i) public view returns(Tweet memory) {
        return tweets[_owner][_i];
    }

    function getAllTweets(address _owner) public view returns(Tweet[] memory) {
        return tweets[_owner];
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }

    function getTweetLength() public view returns(uint) {
        return MAX_TWEET_LENGTH;
    }

    function likeTweet(address author, uint id) external {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST!");
        tweets[author][id].likes++;

        emit TweetLike(author, msg.sender, id, tweets[author][id].likes);
    }

    function unlikeTweet(address author, uint id) external {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST!");
        require(tweets[author][id].likes > 0, "TWEET DOES NOT EXIST!");
        tweets[author][id].likes--;

        emit TweetUnike(author, msg.sender, id, tweets[author][id].likes);
    }

    function getTotalLikes(address _author) external view returns(uint) {
        uint totalLikes;

        for(uint i = 0; i <= tweets[_author].length; i++) {
            totalLikes += tweets[_author][i].likes;
        }
        
        return totalLikes;
    }
}
