pragma solidity ^0.8.18;

contract VotingManager {
    struct Proposal {
        string title;
        string description;
        uint256 voteCount;
        bool exists;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;
    uint256 public proposalCount;
    address public admin;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createProposal(string memory title, string memory description) external onlyAdmin {
        proposals[proposalCount] = Proposal(title, description, 0, true);
        proposalCount++;
    }

    function vote(uint256 proposalId) external {
        require(proposals[proposalId].exists, "Proposal not found");
        require(!hasVoted[msg.sender][proposalId], "Already voted");

        proposals[proposalId].voteCount++;
        hasVoted[msg.sender][proposalId] = true;
    }

    function getResult(uint256 proposalId) external view returns (string memory, uint256) {
        Proposal memory p = proposals[proposalId];
        return (p.title, p.voteCount);
    }
}
