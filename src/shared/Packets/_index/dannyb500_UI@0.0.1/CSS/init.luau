local CSS = {};
local Compiler = require(script.CSS_Compiler);

function CSS:Compile(css_input: string)
    return Compiler:Compile(css_input);
end

function CSS:ApplyStyle(CompiledCode: {any})
    Compiler:ApplyStyle(CompiledCode)
end

return CSS