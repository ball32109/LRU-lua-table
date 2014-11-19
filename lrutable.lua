local double_link_list = {}

function double_link_list:new()
	local ctx = setmetatable({},{__index = self})
	ctx.head = nil
	ctx.tail = ctx.head
	ctx.sz = 0
	return ctx
end

function double_link_list:size()
	return self.sz
end

function double_link_list:new_at_begin(k,v)
	local node = {key = k,value = v,prev = nil,next = nil}
	return self:add_at_begin(node)
end

function double_link_list:new_at_end(k,v)
	local node = {key = k,value = v,prev = nil,next = nil}
	return self:add_at_end(node)
end

function double_link_list:add_at_begin(n)
	self.sz = self.sz + 1
	if self.head == nil then
		self.head = n
		self.tail = n
	end
	n.next = head
	n.prev = nil
	self.head.prev = n
	self.head = n
	return n
end

function double_link_list:add_at_end(n)
	self.sz = self.sz + 1
	if self.head == nil then
		self.head = n
		self.tail = n
		return n
	end
	self.tail.next = n
	n.prev = self.tail
	n.next = nil
	self.tail = n
	return n
end

function double_link_list:unlink(n)
	local before = n.prev
	local after = n.next
	
	if before ~= nil then
		before.next = after
	end

	if after ~= nil then
		after.prev = before
	end

	if self.head == n then
		self.head = self.head.next
	elseif self.tail == n then
		self.tail = self.tail.prev
	end

	self.sz = self.sz - 1
end

function double_link_list:take_to_begin(n)
	self:unlink(n)
	self:add_at_begin(n)
end

function double_link_list:get_tail()
	return self.tail
end

function double_link_list:delete(n)
	print("delete:",self.tail)
	self:unlink(n)
end

function double_link_list:delete_last()
	self:delete(self.tail)
end

local lrutable = {}

function lrutable:new(cap,loader)
	local ctx = setmetatable({},{__index = self})
	ctx.cap = cap
	ctx.loader = loader
	ctx.cachelist = double_link_list:new()
	ctx.table = {}
	return ctx
end

function lrutable:set(k,v)
	local node = self.table[k]
	if node ~= nil then
		node.value = value
		self.cachelist:take_to_begin(node)
	else
		self.cachelist:new_at_begin(k,v)
		if self.cachelist:size() > self.cap then
			local key = self.cachelist:get_tail().key
			self.table[key] = nil
			self.cachelist:delete_last()
		end
	end
end

function lrutable:get(k)
	local node = self.table[k]
	if node ~= nil then
		self.cachelist:take_to_begin(node)
		return node.value
	end

	node = self.loader(k)
	if node ~= nil then
		self:set(k,v)
		return node
	end
end

return lrutable
