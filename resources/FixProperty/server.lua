ESX                     = nil
Items                   = {}
local InventoriesIndex  = {}
local Inventories       = {}
local SharedInventories = {}


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


function CreateAddonInventory(name, owner, items)
print("esx_addoninventory-server-classes-addoninventory - CreateAddonInventory")
	local self = {}

	self.name  = name
	self.owner = owner
	self.items = items

	self.addItem = function(name, count)
		local item = self.getItem(name)
		item.count = item.count + count

		self.saveItem(name, item.count)
	end

	self.removeItem = function(name, count)
		local item = self.getItem(name)
		item.count = item.count - count

		self.saveItem(name, item.count)
	end

	self.setItem = function(name, count)
		local item = self.getItem(name)
		item.count = count

		self.saveItem(name, item.count)
	end

	self.getItem = function(name)
		for i=1, #self.items, 1 do
			if self.items[i].name == name then
				return self.items[i]
			end
		end

		item = {
			name  = name,
			count = 0,
			label = Items[name]
		}

		table.insert(self.items, item)

		if self.owner == nil then
			MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count) VALUES (@inventory_name, @item_name, @count)',
			{
				['@inventory_name'] = self.name,
				['@item_name']      = name,
				['@count']          = 0
			})
		else
			MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count, owner) VALUES (@inventory_name, @item_name, @count, @owner)',
			{
				['@inventory_name'] = self.name,
				['@item_name']      = name,
				['@count']          = 0,
				['@owner']          = self.owner
			})
		end

		return item
	end

	self.saveItem = function(name, count)
		if self.owner == nil then
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name',
			{
				['@inventory_name'] = self.name,
				['@item_name']      = name,
				['@count']          = count
			})
		else
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name AND owner = @owner',
			{
				['@inventory_name'] = self.name,
				['@item_name']      = name,
				['@count']          = count,
				['@owner']          = self.owner
			})
		end
	end

	return self
end


RegisterCommand('fixinv', function(source)
local items = MySQL.Sync.fetchAll('SELECT * FROM items')

	for i=1, #items, 1 do
		Items[items[i].name] = items[i].label
	end

	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory')

	for i=1, #result, 1 do
		local name   = result[i].name
		local label  = result[i].label
		local shared = result[i].shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory_items WHERE inventory_name = @inventory_name', {
			['@inventory_name'] = name
		})

		if shared == 0 then

			table.insert(InventoriesIndex, name)

			Inventories[name] = {}
			local items       = {}

			for j=1, #result2, 1 do
				local itemName  = result2[j].name
				local itemCount = result2[j].count
				local itemOwner = result2[j].owner

				if items[itemOwner] == nil then
					items[itemOwner] = {}
				end

				table.insert(items[itemOwner], {
					name  = itemName,
					count = itemCount,
					label = Items[itemName]
				})
			end

			for k,v in pairs(items) do
				local addonInventory = CreateAddonInventory(name, k, v)
				table.insert(Inventories[name], addonInventory)
			end

		else

			local items = {}

			for j=1, #result2, 1 do
				table.insert(items, {
					name  = result2[j].name,
					count = result2[j].count,
					label = Items[result2[j].name]
				})
			end

			local addonInventory    = CreateAddonInventory(name, nil, items)
			SharedInventories[name] = addonInventory

		end
	end
	end)