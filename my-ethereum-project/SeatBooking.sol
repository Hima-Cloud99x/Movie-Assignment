// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SeatBooking {
    address public owner;
    uint256 public seatPrice = 1 ether;
    uint256 public totalSeats = 20;
    
    mapping(address => uint256[]) public userSeats;
    mapping(uint256 => address) public seatToOwner;
    
    event SeatBooked(address indexed user, uint256 seatNumber);

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }
    
    modifier validSeat(uint256 seatNumber) {
        require(seatNumber > 0 && seatNumber <= totalSeats, "Invalid seat number");
        _;
    }
    
    function bookSeat(uint256 seatNumber) external payable validSeat(seatNumber) {
        require(seatToOwner[seatNumber] == address(0), "Seat is already booked");
        require(msg.value == seatPrice, "Incorrect payment amount");

        seatToOwner[seatNumber] = msg.sender;
        userSeats[msg.sender].push(seatNumber);
        
        emit SeatBooked(msg.sender, seatNumber);
    }
    
    function getBookedSeats() external view returns (uint256[] memory) {
        return userSeats[msg.sender];
    }

    function getAvailableSeats() external view returns (uint256[] memory) {
        uint256[] memory availableSeats = new uint256[](totalSeats);
        uint256 count = 0;

        for (uint256 i = 1; i <= totalSeats; i++) {
            if (seatToOwner[i] == address(0)) {
                availableSeats[count] = i;
                count++;
            }
        }

        return availableSeats;
    }
    
    function calculateTotalCost() external view returns (uint256) {
        uint256[] memory selectedSeats = userSeats[msg.sender];
        uint256 totalCost = selectedSeats.length * seatPrice;
        return totalCost;
    }
    
    function withdrawFunds() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
