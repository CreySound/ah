local f3x = {}
function f3x:getf3x()
	if not game.Players.LocalPlayer:WaitForChild("Backpack"):FindFirstChild("Folder") then
		game.Players:Chat(":f3x")
	end
	local folder = game.Players.LocalPlayer:WaitForChild("Backpack"):WaitForChild("Folder")
	return folder:WaitForChild("SyncAPI"):WaitForChild("ServerEndpoint")
end

function f3x:changeprops(Part, Props)
	local folder = game.Players.LocalPlayer:WaitForChild("Backpack"):WaitForChild("Folder")

	local PropData = {}
	for i, v in next, Props do
		PropData[tostring(i) .. "\0"] = v
	end


	folder:WaitForChild("SyncAPI"):WaitForChild("ServerEndpoint"):InvokeServer("SyncSurface", {{
		Part = Part,
		Surfaces = PropData
	}})
end

function f3x:makepart(position, size, color, material)
	if size == nil then
		size = Vector3.new(3,3,3)
	end
	if color == nil then
		color = Color3.fromRGB(163, 162, 165)
	end
	if material == nil then
		material = Enum.Material.Plastic
	end
	local args = {
		[1] = "CreatePart",
		[2] = "Normal",
		[3] = position,
		[4] = workspace
	}

	local part = f3x:getf3x():InvokeServer(unpack(args))

	f3x:changeprops(part, {["Anchored"] = true, ["Size"] = size, ["Color"] = color, ["Material"] = material})
	return part
end

function f3x:maketext(text, pos : Vector3)
	local char = game.Players.LocalPlayer.Characetr
	local ogname = char.Name 
	local ogdisp = char.Humanoid.DisplayName
	char.Name = "Original_Character"
	local bodyparts = {"Head", "HumanoidRootPart"}
	local cloneparts = {}
	for i,v in pairs(char:GetChildren()) do
		if v:IsA("BasePart") then
			table.insert(cloneparts, v)
		end
	end
	game.Players:Chat(":unlock|:dname me "..text)
	repeat
		wait()
	until char.Head.Locked == false and char.Humanoid.DisplayName ~= ogdisp

	f3x:getf3x():InvokeServer("Clone", {char}, workspace)
	local replicatechar = game.Workspace:WaitForChild(ogname)
	replicatechar.Name = "OP_Text"
	for i,v in pairs(replicatechar:GetChildren()) do
		coroutine.wrap(function()
			if not table.find(bodyparts, v.Name) then

				f3x:getf3x():InvokeServer("Remove", {v})
			else
				f3x:getf3x():InvokeServer("SyncAnchor", {{["Part"] = v, ["Anchored"] = true}})
				f3x:getf3x():InvokeServer("SyncMove", {{["Part"] = v, ["CFrame"] = CFrame.new(pos)}})
			end
		end)()
		task.wait()
	end
	char.Name = ogname
	game.Players:Chat(":undname me|:lock me")
	wait(.5)
	return replicatechar
end

function f3x:getpart(startmodel, part)


	local parents = {}
	for i,v in pairs(startmodel:GetDescendants()) do
		if v == part then
			local currentpart = v.Parent
			repeat
				table.insert(parents, 1, currentpart)
				currentpart = currentpart.Parent
				wait()
			until currentpart == startmodel
			table.insert(parents, 1, currentpart)
		end
	end
	for i,v in pairs(parents) do
		local args = {
			[1] = "Ungroup",
			[2] = {
				[1] = v
			}
		}

		local starter = f3x:getf3x():InvokeServer(unpack(args))
	end

	return part


end
return f3x
