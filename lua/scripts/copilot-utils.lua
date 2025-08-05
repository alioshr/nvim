---Transform Copilot completion items to have a distinct "Copilot" kind
---@param _ any Unused first parameter
---@param items blink.cmp.CompletionItem[] Array of completion items from Copilot
---@return blink.cmp.CompletionItem[] The same items with modified kind property
local function transform_copilot_items(_, items)
  local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
  local kind_idx = #CompletionItemKind + 1
  CompletionItemKind[kind_idx] = "Copilot"

  for _, item in ipairs(items) do
    item.kind = kind_idx
  end

  return items
end

return {
  transform_copilot_items = transform_copilot_items,
}