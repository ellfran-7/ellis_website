-- cvdate-filter.lua
-- Intercepts [text]{.cvdate} spans and converts them to a
-- raw Typst function call #cvdate([...]) during Typst rendering.
-- In HTML output, the span is left untouched so CSS can target it.

function Span(el)
-- Only act on spans that carry the .cvdate class
if not el.classes:includes("cvdate") then
return nil  -- return nil = leave the node unchanged
end

-- For Typst output: emit a raw inline Typst function call
if FORMAT == "typst" then
-- Serialize the span's inner inlines back to Pandoc inlines,
    -- then wrap them in a Typst content block [...]
    -- We use pandoc.write to convert the inner content to Typst string
    local inner = pandoc.write(pandoc.Pandoc(pandoc.Plain(el.content)), "typst")
    -- Trim the trailing newline pandoc.write adds
    inner = inner:gsub("%s+$", "")
    local raw = "#cvdate([" .. inner .. "])"
    return pandoc.RawInline("typst", raw)
  end

  -- For HTML output: leave the span intact so CSS flexbox works
  -- (Quarto will render it as <span class="cvdate">...</span>)
  return nil
end