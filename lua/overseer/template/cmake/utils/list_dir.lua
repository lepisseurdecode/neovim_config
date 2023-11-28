local build_name = '.nvim.cmake'
local file_name = build_name .. '/list_dir.json'
local M = {}

local function is_exists(file)
	file = file or file_name
	return vim.loop.fs_stat(file) ~= nil
end

local function clean(datas)
	for i, data in ipairs(datas) do
		if not is_exists(data.build_dir) then
			table.remove(datas, i)
		end
	end
	return datas
end

local function read()
	if not is_exists() then return {} end
	local content = ''
	for line in io.lines(file_name) do
		content = content .. line
	end
	return clean(vim.json.decode(content)) or {}
end

local function write(datas)
	if not is_exists() then
		vim.loop.fs_mkdir(build_name, 777)
	end
	local file = io.open(file_name, 'w')
	if nil ~= file then
		file:write(vim.json.encode(datas))
		file:close()
	end
end

function M.get()
	local datas = read()
	local res = {}
	res.prvt = {}
	res.prvt.current = {}
	res.prvt.datas = datas
	for _, data in ipairs(datas) do
		if data.is_current then
			res.prvt.current = data
		end
	end
	res.current = function(self) return self.prvt.current.build_dir end
	res.config = function(self) return self.prvt.current.config end
	res.set_config = function(self, config) self.prvt.current.config = config end
	res.target = function(self) return self.prvt.current.target end
	res.set_target = function(self, target) self.prvt.current.target = target end
	res.install_prefix = function(self) return self.prvt.current.install_prefix end
	res.set_install_prefix = function(self, prefix) self.prvt.current.install_prefix = prefix end
	res.variables_environment = function(self) return self.prvt.current.variables_environment end
	res.set_variables_environment = function(self, env_vars) self.prvt.current.variables_environment = env_vars end
	res.working_directory = function(self) return self.prvt.current.working_directory end
	res.set_working_directory = function(self, wd) self.prvt.current.working_directory = wd end
	res.launch_params = function(self) return self.prvt.current.launch_params end
	res.set_launch_params = function(self, params) self.prvt.current.launch_params = params end
	res.write = function(self) write(self.prvt.datas) end
	res.empty = function(self) return #self.prvt.datas == 0 end
	res.count = function(self) return #self.prvt.datas end

	res.add = function(self, name)
		for _, data in pairs(self.prvt.datas) do
			if data.build_dir == name then
				return
			end
		end
		table.insert(self.prvt.datas, {build_dir = name})
		self:set_current(name)
	end

	res.available_dirs = function(self)
		local dirs = {}
		for _, data in pairs(self.prvt.datas) do
			table.insert(dirs, data.build_dir)
		end
		return dirs
	end

	res.set_current = function(self, name)
		for _, data in pairs(self.prvt.datas) do
			if name == data.build_dir then
				data.is_current = true
				self.prvt.current = data
			else
				data.is_current = false
			end
		end
	end
	return res
end

return M
