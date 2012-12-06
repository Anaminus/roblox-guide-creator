local Plugin = PluginManager():CreatePlugin()
local Toolbar = Plugin:CreateToolbar("Plugins")
local Button = Toolbar:CreateButton("","Guide Cycle [Part > Guide > Invisible > Part]","part_to_guide.png")

local guide_container_parent = Game
local guide_container_name = "Guides"
local metadata_name = "__GUIDE_METADATA"

local GuideContainer = guide_container_parent:FindFirstChild(guide_container_name)
if not GuideContainer then
	GuideContainer = Instance.new("Model")
	GuideContainer.Name = guide_container_name
end

local function ReparentGuideContainer()
	if #GuideContainer:GetChildren() > 0 then
		GuideContainer.Parent = guide_container_parent
	else
		GuideContainer.Parent = nil
	end
end

GuideContainer.ChildAdded:connect(ReparentGuideContainer)
GuideContainer.ChildRemoved:connect(ReparentGuideContainer)

local Selection = Game:GetService("Selection")
local CoreGui = Game:GetService("CoreGui")

local function CreateTag(type,name,value)
	local tag = Instance.new((type or "String").."Value")
	tag.Name = name or "Tag"
	if value then tag.Value = value end
	return tag
end

local function CreateMetadata(part)
	local meta = Instance.new("Configuration")
	meta.Name = metadata_name
	CreateTag("Object","Parent",part.Parent).Parent = meta
	CreateTag("Bool","Visible",true).Parent = meta
	meta.Parent = part
end

local function GetMetadata(part,name,get_tag)
	local meta = part:FindFirstChild(metadata_name)
	if meta then
		local tag = meta:FindFirstChild(name)
		if tag then
			return get_tag and tag or tag.Value
		end
	end
	return nil
end

local guideLookup = {}

local function CreateGuide(part)
	local guide = Instance.new("SelectionBox")
	guide.Name = part.Name.."Guide"
	guide.Color = part.BrickColor
	guide.Adornee = part
	guide.Archivable = false
	guide.Parent = CoreGui
	guideLookup[part] = guide

	local visible = GetMetadata(part,"Visible")
	guide.Visible = visible == nil and true or visible
end

local function ToGuide(part)
	CreateMetadata(part)
	CreateGuide(part)
	part.Parent = GuideContainer
end

local function ToInvisibleGuide(part)
	local guide = guideLookup[part]
	if guide ~= nil then
		guide.Visible = false
	end

	local tag = GetMetadata(part,"Visible",true)
	if tag ~= nil then
		tag.Value = false
	end
end

local function ToPart(part)
	local parent = Workspace
	local meta = part:FindFirstChild(metadata_name)
	if meta then
		local tag = meta:FindFirstChild("Parent")
		if tag then
			parent = tag.Value or Workspace
		end
		meta:Destroy()
	end
	local guide = guideLookup[part]
	if guide ~= nil then
		guideLookup[part] = nil
		guide:Destroy()
	end
	part.Parent = parent:IsDescendantOf(Game) and parent or Workspace
end

Button.Click:connect(function()
	for _,object in pairs(Selection:Get()) do
		if object:IsA"BasePart" and not object:IsA"Terrain" then
			if object:IsDescendantOf(GuideContainer) then
				local visible = GetMetadata(object,"Visible")
				if visible then
					ToInvisibleGuide(object)
				else
					ToPart(object)
				end
			else
				ToGuide(object)
			end
		end
	end
end)

for _,part in pairs(GuideContainer:GetChildren()) do
	CreateGuide(part)
end

ReparentGuideContainer()
