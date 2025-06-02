pragma solidity ^0.8.18;

contract DonationManager {
    struct Campaign {
        string name;
        string purpose;
        uint256 totalDonated;
        bool exists;
        address creator;
    }

    mapping(uint256 => Campaign) public campaigns;
    uint256 public campaignCount;

    event Donated(address indexed donor, uint256 amount, uint256 campaignId);

    function createCampaign(string memory name, string memory purpose) external {
        campaigns[campaignCount] = Campaign(name, purpose, 0, true, msg.sender);
        campaignCount++;
    }

    function donate(uint256 campaignId) external payable {
        require(campaigns[campaignId].exists, "Campaign not found");
        campaigns[campaignId].totalDonated += msg.value;
        emit Donated(msg.sender, msg.value, campaignId);
    }

    function withdraw(uint256 campaignId, address payable to) external {
        Campaign memory c = campaigns[campaignId];
        require(msg.sender == c.creator, "Not creator");
        uint256 amount = c.totalDonated;
        campaigns[campaignId].totalDonated = 0;
        to.transfer(amount);
    }
}
