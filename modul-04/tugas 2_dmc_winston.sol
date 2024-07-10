// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract DecentralizedMarketplace {

    // Struct to represent an item
    struct Item {
        uint256 id;
        string name;
        uint256 price;
        address payable seller;
        address buyer;
        bool sold;
    }

    // Mapping to store items by their ID
    mapping(uint256 => Item) public items;

    // Mapping to track which user owns which item
    mapping(address => uint256[]) public userOwnedItems;

    // Counter for unique IDs
    uint256 private itemIdCounter;

    // Event emitted when a new item is listed
    event ItemListed(uint256 id, string name, uint256 price, address seller);

    // Event emitted when an item is purchased
    event ItemPurchased(uint256 id, address buyer);

    // Event emitted when funds are withdrawn
    event FundsWithdrawn(address seller, uint256 amount);

    // Function to list an item for sale
    function listItem(string memory _name, uint256 _price) public {
        require(bytes(_name).length > 0, "Item name is required");
        require(_price > 0, "Item price must be greater than zero");

        // Increment the item ID counter
        uint256 newItemId = itemIdCounter++;

        // Create a new item struct
        Item memory newItem = Item({
            id: newItemId,
            name: _name,
            price: _price,
            seller: payable(msg.sender),
            buyer: address(0),
            sold: false
        });

        // Store the new item in the mapping
        items[newItemId] = newItem;

        // Emit the ItemListed event
        emit ItemListed(newItemId, _name, _price, msg.sender);
    }

    // Function to purchase a listed item
    function purchaseItem(uint256 _itemId) public payable {
        // Ensure the item exists
        Item storage item = items[_itemId];
        require(item.id == _itemId, "Item does not exist");

        // Ensure the item is not sold yet
        require(!item.sold, "Item is already sold");

        // Ensure the purchase amount matches the price of the item
        require(msg.value == item.price, "Incorrect amount of Ether sent");

        // Transfer ownership of the item
        item.buyer = msg.sender;
        item.sold = true;

        // Track the new owner's item
        userOwnedItems[msg.sender].push(_itemId);

        // Emit the ItemPurchased event
        emit ItemPurchased(_itemId, msg.sender);

        // Transfer the payment to the seller
        item.seller.transfer(msg.value);
    }

    // Function to withdraw funds earned from selling items
    function withdrawFunds() public {
        uint256 amount = address(this).balance;
        require(amount > 0, "No funds available for withdrawal");

        // Transfer the balance to the caller
        payable(msg.sender).transfer(amount);

        // Emit the FundsWithdrawn event
        emit FundsWithdrawn(msg.sender, amount);
    }
}
