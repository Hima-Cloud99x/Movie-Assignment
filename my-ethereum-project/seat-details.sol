// Import Web3.js library and create a Web3 instance
const Web3 = require('web3');
const web3 = new Web3('ETHEREUM_NODE_URL'); // Not Connected

// Import the ABI and contract address of your deployed SeatBooking smart contract
const seatBookingABI = [...]; // Replace with your contract's ABI
const seatBookingAddress = 'CONTRACT_ADDRESS'; // Not Connected

// Create a contract instance
const seatBookingContract = new web3.eth.Contract(seatBookingABI, seatBookingAddress);

// Function to parse query parameters from URL
function getQueryParameter(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

// Retrieve and display seat details
async function displaySeatDetails() {
    const selectedSeatNumber = getQueryParameter('seat');

    if (!selectedSeatNumber) {
        document.getElementById('seat-details').textContent = 'No seat selected.';
        return;
    }

    try {
        // Fetch the booked seats, available seats, and total cost from the contract
        const bookedSeats = await seatBookingContract.methods.getBookedSeats().call();
        const availableSeats = await seatBookingContract.methods.getAvailableSeats().call();
        const totalCost = await seatBookingContract.methods.calculateTotalCost().call();

        // Display the seat details on the HTML page
        document.getElementById('seat-details').textContent = `Selected Seat: Seat ${selectedSeatNumber}\n` +
            `Booked Seats: ${bookedSeats.join(', ')}\n` +
            `Available Seats: ${availableSeats.join(', ')}\n` +
            `Total Cost: $${web3.utils.fromWei(totalCost.toString(), 'ether')}`; // Convert totalCost to ether
    } catch (error) {
        console.error('Error fetching seat details:', error);
        document.getElementById('seat-details').textContent = 'Error fetching seat details.';
    }
}

// Call the function to display seat details when the page loads
displaySeatDetails();
