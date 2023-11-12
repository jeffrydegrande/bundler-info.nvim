local function find_string_in_buffer(buffer, string_to_find)
    local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
    local full_string_to_find = 'gem "' .. string_to_find .. '"'

    for i, line in ipairs(lines) do
        if string.find(line, full_string_to_find) then
            return i - 1
        end
    end
end

local function setup()
    --setup autocmd for Gemfile
    vim.api.nvim_create_autocmd("BufRead", {
        pattern = "Gemfile",
        group = vim.api.nvim_create_augroup(
            "jeffrydegrande_bundler_info",
            { clear = true }
        ),
        callback = function()
            local current_buffer = vim.api.nvim_get_current_buf()

            vim.fn.jobstart("bundle outdated --porcelain", {
                stdout_buffered = true,
                on_stdout = function(_, data, _)
                    if not data then
                        return
                    end

                    local versions = {}

                    for _, line in ipairs(data) do
                        if line ~= "" then
                            local name, newest, installed =
                                string.match(line, "(%S+) %(([^,]+), ([^)]+)%)")

                            local line_number =
                                find_string_in_buffer(current_buffer, name)

                            if line_number == nil then
                                goto continue
                            end

                            local message = newest .. ", " .. installed

                            table.insert(versions, {
                                bufnr = current_buffer,
                                lnum = line_number,
                                col = 0,
                                -- TODO: add a system that bumps severity if things get out of date
                                severity = vim.diagnostic.severity.INFO,
                                source = "bundler-info",
                                message = message,
                                user_data = {},
                            })
                            -- are we really doing goto?
                            ::continue::
                        end
                    end

                    ns = vim.api.nvim_create_namespace("jeffrydegrande_bundler_info")
                    vim.diagnostic.set(ns, current_buffer, versions, {})
                end,
            })
        end,
    })
end

return {
    setup = setup,
}
