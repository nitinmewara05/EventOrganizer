// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.8.21;

contract EventContract {
    struct Event {
        address organiser;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }
    mapping(uint => Event) public events;
    mapping(address => mapping(uint => uint)) public tickets;
    uint public nextId;

    function createEvent(
        string memory name,
        uint date,
        uint price,
        uint ticketCount
    ) external {
        require(
            date > block.timestamp,
            "You can organize event for furture date"
        );
        require(
            ticketCount > 0,
            "You can organize event only if you create more than 0 tickets"
        );
        events[nextId] = Event(
            msg.sender,
            name,
            date,
            price,
            ticketCount,
            ticketCount
        );
        nextId++;
    }

    function buyTicket(uint id, uint quantity) external payable {
        require(events[id].date != 0, "Event does not available");
        require(events[id].date > block.timestamp, "Event has already over");
        Event storage _event = events[id];
        require(msg.value == (_event.price*quantity), "Insufficient Funds");
        require(_event.ticketRemain>=quantity, "Event fully booked");
        _event.ticketRemain = quantity;
        tickets[msg.sender][id] += quantity;
    }

    function transferTickets(
        uint id,
        uint quantity,
        address to
    ) external {
        require(events[id].date != 0, "Event does not available");
        require(events[id].date>block.timestamp, "Event fully booked");
        require(
            tickets[msg.sender][id] > quantity,
            "you do not have enough tickets"
        );
        tickets[msg.sender][id] += quantity;
        tickets[to][id] += quantity;
    }
}
