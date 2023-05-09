pragma solidity ^0.8.0;
contract PeerToPeerInsurance {
    uint public poolSize;
    uint public excessLimit;
    uint public operatingCosts;
    uint public reinsuranceCosts;
    uint public surplus;
    address[] public members;
    mapping(address => uint) public contributions;
    event MemberAdded(address indexed member);
    event ContributionMade(address indexed member, uint amount);
    function addMember(address member) public {
        members.push(member);
        emit MemberAdded(member);}
    function makeContribution() public payable {
        require(isMember(msg.sender), "Sender is not a member of the insurance pool.");
        contributions[msg.sender] += msg.value;
        poolSize += msg.value;
        emit ContributionMade(msg.sender, msg.value);}
    function isMember(address member) public view returns(bool) {
        for (uint i = 0; i < members.length; i++) {
            if (members[i] == member) {
                return true;}}
        return false;}
    function calculateCostGroupCovered() public view returns(uint) {
        uint premium = ((1 + reinsuranceCosts) * (poolSize - operatingCosts - excessLimit)) / (1 - surplus/poolSize);
        uint cost = premium / members.length;
        surplus = poolSize - premium;
        return cost;}
    function calculateCostIndividuallyCovered() public view returns(uint) {
        uint premium = ((1 + reinsuranceCosts) * (poolSize - operatingCosts)) / (1 - surplus/poolSize);
        uint cost = premium / members.length;
        surplus = poolSize - premium;
        return cost;}}
