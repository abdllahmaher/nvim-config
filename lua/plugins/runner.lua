--
-- return {
--   "CRAG666/code_runner.nvim",
--   lazy = false,
--   config = function()
--     require("code_runner").setup({
--       -- Use terminal mode instead of toggleterm for cleaner output
--       mode = "term",
--
--       -- Focus on runner window
--       focus = true,
--
--       -- Don't start in insert mode (to avoid accidental typing)
--       startinsert = false,
--
--       -- Terminal configuration - cleaner setup
--       term = {
--         position = "botright", -- or "botright" for bottom terminal
--         size = 30, -- Width for vertical, height for horizontal
--       },
--
--       -- Filetype-specific commands
--       filetype = {
--         -- JavaScript/Node.js
--         javascript = "node $fileName",
--         js = "node $fileName",
--
--         -- TypeScript
--         typescript = "npx ts-node $fileName",
--         ts = "npx ts-node $fileName",
--
--         -- Python
--         python = "python3 $fileName",
--         py = "python3 $fileName",
--
--         -- C++ - Fixed: Only compile files with main() function
--         cpp = function()
--           local filename = vim.fn.expand("%:p")
--           local base_name = vim.fn.expand("%:r")
--
--           -- Check if file contains main() function
--           local file = io.open(filename, "r")
--           if file then
--             local content = file:read("*all")
--             file:close()
--
--             if content:match("int%s+main%s*%(") or content:match("void%s+main%s*%(") or content:match("main%s*%(") then
--               -- File has main(), compile and run
--               return {
--                 "cd $dir &&",
--                 "g++ -std=c++17 -Wall $fileName -o $fileNameWithoutExt &&",
--                 "echo 'Program output:' &&",
--                 "./$fileNameWithoutExt &&",
--                 "echo -e '\\n\\033[0;32m✓ Program finished successfully\\033[0m' ||",
--                 "echo -e '\\n\\033[0;31m✗ Program failed with exit code $?\\033[0m'",
--               }
--             else
--               -- File doesn't have main(), just compile
--               return {
--                 "cd $dir &&",
--                 "g++ -std=c++17 -Wall $fileName -o $fileNameWithoutExt &&",
--                 "echo '✓ Compilation successful (no main() to run)'",
--               }
--             end
--           end
--           return ""
--         end,
--
--         -- C - Similar logic
--         c = function()
--           local filename = vim.fn.expand("%:p")
--           local file = io.open(filename, "r")
--           if file then
--             local content = file:read("*all")
--             file:close()
--
--             if content:match("int%s+main%s*%(") or content:match("void%s+main%s*%(") or content:match("main%s*%(") then
--               return {
--                 "cd $dir &&",
--                 "gcc -Wall $fileName -o $fileNameWithoutExt &&",
--                 "echo 'Program output:' &&",
--                 "./$fileNameWithoutExt &&",
--                 "echo -e '\\n\\033[0;32m✓ Program finished successfully\\033[0m' ||",
--                 "echo -e '\\n\\033[0;31m✗ Program failed with exit code $?\\033[0m'",
--               }
--             else
--               return {
--                 "cd $dir &&",
--                 "gcc -Wall $fileName -o $fileNameWithoutExt &&",
--                 "echo '✓ Compilation successful (no main() to run)'",
--               }
--             end
--           end
--           return ""
--         end,
--
--         -- Java
--         java = {
--           "cd $dir &&",
--           "javac $fileName &&",
--           "echo 'Program output:' &&",
--           "java $fileNameWithoutExt &&",
--           "echo -e '\\n\\033[0;32m✓ Program finished\\033[0m' ||",
--           "echo -e '\\n\\033[0;31m✗ Program failed\\033[0m'",
--         },
--
--         -- Go
--         go = "go run $fileName",
--
--         -- Rust
--         rust = {
--           "cd $dir &&",
--           "rustc $fileName -o $fileNameWithoutExt &&",
--           "./$fileNameWithoutExt",
--         },
--
--         -- Shell scripts
--         sh = "bash $fileName",
--         bash = "bash $fileName",
--       },
--
--       -- Custom function to clean up output
--       before_run_filetype = function()
--         -- Clear terminal before running (if in term mode)
--         vim.cmd("sleep 100m") -- Small delay
--       end,
--     })
--
--     -- Custom function for cleaner execution
--     local function clean_run_file()
--       -- Get current filetype
--       local ft = vim.bo.filetype
--       local filename = vim.fn.expand("%:p")
--
--       -- For C/C++ files, check if they have main() function
--       if ft == "cpp" or ft == "c++" or ft == "c" then
--         local file = io.open(filename, "r")
--         if file then
--           local content = file:read("*all")
--           file:close()
--
--           if
--             not (content:match("int%s+main%s*%(") or content:match("void%s+main%s*%(") or content:match("main%s*%("))
--           then
--             -- Ask user if they want to compile only
--             vim.ui.select(
--               { "Compile only", "Cancel" },
--               { prompt = "File doesn't have main() function. What to do?" },
--               function(choice)
--                 if choice == "Compile only" then
--                   local cmd
--                   if ft == "cpp" or ft == "c++" then
--                     cmd = "cd $dir && g++ -std=c++17 -Wall $fileName -o $fileNameWithoutExt"
--                   else
--                     cmd = "cd $dir && gcc -Wall $fileName -o $fileNameWithoutExt"
--                   end
--                   require("code_runner.commands").run_from_fn(cmd)
--                 end
--               end
--             )
--             return
--           end
--         end
--       end
--
--       -- Run the file normally
--       vim.cmd("RunFile")
--     end
--
--     -- Map F5 to our cleaner function
--     vim.keymap.set("n", "<F5>", clean_run_file, {
--       noremap = true,
--       silent = true,
--       desc = "Run current file",
--     })
--
--     -- Visual mode: Run selected code with cleaner output
--     vim.keymap.set("v", "<F5>", function()
--       local ft = vim.bo.filetype
--       local temp_file = vim.fn.tempname() .. "." .. ft
--
--       -- Get visual selection
--       local start_line = vim.fn.line("'<")
--       local end_line = vim.fn.line("'>")
--       local lines = vim.fn.getline(start_line, end_line)
--       vim.fn.writefile(lines, temp_file)
--
--       -- Clean command based on filetype
--       local cmd = ""
--       if ft == "python" or ft == "py" then
--         cmd = "python3 " .. temp_file .. " && echo -e '\\n\\033[0;32m✓ Done\\033[0m'"
--       elseif ft == "javascript" or ft == "js" then
--         cmd = "node " .. temp_file .. " && echo -e '\\n\\033[0;32m✓ Done\\033[0m'"
--       elseif ft == "cpp" or ft == "c++" then
--         local base_temp = temp_file:gsub("%..*$", "")
--         cmd = "g++ -std=c++17 "
--           .. temp_file
--           .. " -o "
--           .. base_temp
--           .. " && echo 'Program output:' && ./"
--           .. base_temp
--           .. " && echo -e '\\n\\033[0;32m✓ Program finished\\033[0m' || "
--           .. "echo -e '\\n\\033[0;31m✗ Compilation/Runtime error\\033[0m'"
--       elseif ft == "c" then
--         local base_temp = temp_file:gsub("%..*$", "")
--         cmd = "gcc "
--           .. temp_file
--           .. " -o "
--           .. base_temp
--           .. " && echo 'Program output:' && ./"
--           .. base_temp
--           .. " && echo -e '\\n\\033[0;32m✓ Program finished\\033[0m' || "
--           .. "echo -e '\\n\\033[0;31m✗ Compilation/Runtime error\\033[0m'"
--       elseif ft == "typescript" or ft == "ts" then
--         cmd = "npx ts-node " .. temp_file .. " && echo -e '\\n\\033[0;32m✓ Done\\033[0m'"
--       else
--         vim.notify("Cannot run selection for file type: " .. ft, vim.log.levels.WARN)
--         return
--       end
--
--       -- Run with cleaner output
--       require("code_runner.commands").run_from_fn(cmd)
--     end, { noremap = true, silent = true, desc = "Run selected code" })
--
--     print("✅ Code Runner loaded! Press F5 to run your code.")
--   end,
-- }
--
--
--
--
--
return {
  "CRAG666/code_runner.nvim",
  lazy = false,
  config = function()
    require("code_runner").setup({
      mode = "term",
      focus = true,
      startinsert = false,
      term = {
        position = "botright",
        size = 12,
      },

      -- SIMPLIFIED filetype commands - No complex bash scripting
      filetype = {
        -- JavaScript/Node.js
        javascript = "node $fileName",
        js = "node $fileName",

        -- TypeScript
        typescript = "npx ts-node $fileName",
        ts = "npx ts-node $fileName",

        -- Python
        python = "python3 $fileName",
        py = "python3 $fileName",

        -- C++ - Simple compilation and run
        cpp = "cd $dir && g++ -std=c++17 -Wall $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",

        -- C - Simple compilation and run
        c = "cd $dir && gcc -Wall $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",

        -- Java
        java = "cd $dir && javac $fileName && java $fileNameWithoutExt",

        -- Go
        go = "cd $dir && go run $fileName",

        -- Rust
        rust = "cd $dir && rustc $fileName && ./$fileNameWithoutExt",

        -- Shell scripts
        sh = "bash $fileName",
        bash = "bash $fileName",
      },
    })

    -- Custom function to run with cleaner output
    local function run_with_clean_output()
      local ft = vim.bo.filetype
      local filename = vim.fn.expand("%:p")
      local dir = vim.fn.expand("%:p:h")
      local basename = vim.fn.expand("%:t:r")

      -- Build command based on filetype
      local cmd = ""

      if ft == "python" or ft == "py" then
        cmd = "cd '" .. dir .. "' && python3 '" .. filename .. "'"
      elseif ft == "javascript" or ft == "js" then
        cmd = "cd '" .. dir .. "' && node '" .. filename .. "'"
      elseif ft == "typescript" or ft == "ts" then
        cmd = "cd '" .. dir .. "' && npx ts-node '" .. filename .. "'"
      elseif ft == "cpp" or ft == "c++" then
        cmd = "cd '"
          .. dir
          .. "' && g++ -std=c++17 -Wall '"
          .. filename
          .. "' -o '"
          .. basename
          .. "' && ./'"
          .. basename
          .. "'"
      elseif ft == "c" then
        cmd = "cd '" .. dir .. "' && gcc -Wall '" .. filename .. "' -o '" .. basename .. "' && ./'" .. basename .. "'"
      elseif ft == "java" then
        cmd = "cd '" .. dir .. "' && javac '" .. filename .. "' && java '" .. basename .. "'"
      elseif ft == "go" then
        cmd = "cd '" .. dir .. "' && go run '" .. filename .. "'"
      elseif ft == "rust" then
        cmd = "cd '" .. dir .. "' && rustc '" .. filename .. "' && ./'" .. basename .. "'"
      elseif ft == "sh" or ft == "bash" then
        cmd = "cd '" .. dir .. "' && bash '" .. filename .. "'"
      else
        vim.notify("Unsupported file type: " .. ft, vim.log.levels.WARN)
        return
      end

      -- Run the command
      require("code_runner.commands").run_from_fn(cmd)
    end

    -- F5 mapping using our custom function
    vim.keymap.set("n", "<F5>", run_with_clean_output, {
      noremap = true,
      silent = true,
      desc = "Run current file",
    })

    -- Visual mode F5 - run selected code
    vim.keymap.set("v", "<F5>", function()
      local ft = vim.bo.filetype
      local temp_file = os.tmpname() .. "." .. ft

      -- Get visual selection
      local start_line = vim.fn.line("'<")
      local end_line = vim.fn.line("'>")
      local lines = {}
      for i = start_line, end_line do
        table.insert(lines, vim.fn.getline(i))
      end

      -- Write to temp file
      local file = io.open(temp_file, "w")
      if file then
        file:write(table.concat(lines, "\n"))
        file:close()
      else
        vim.notify("Failed to create temp file", vim.log.levels.ERROR)
        return
      end

      -- Build command for selected code
      local cmd = ""
      if ft == "python" or ft == "py" then
        cmd = "python3 '" .. temp_file .. "'"
      elseif ft == "javascript" or ft == "js" then
        cmd = "node '" .. temp_file .. "'"
      elseif ft == "typescript" or ft == "ts" then
        cmd = "npx ts-node '" .. temp_file .. "'"
      elseif ft == "cpp" or ft == "c++" then
        local base_temp = temp_file:gsub("%..*$", "")
        cmd = "g++ -std=c++17 '" .. temp_file .. "' -o '" .. base_temp .. "' && ./'" .. base_temp .. "'"
      elseif ft == "c" then
        local base_temp = temp_file:gsub("%..*$", "")
        cmd = "gcc '" .. temp_file .. "' -o '" .. base_temp .. "' && ./'" .. base_temp .. "'"
      else
        vim.notify("Cannot run selection for: " .. ft, vim.log.levels.WARN)
        return
      end

      -- Run the command
      require("code_runner.commands").run_from_fn(cmd)
    end, { noremap = true, silent = true, desc = "Run selected code" })

    print("✅ Code Runner loaded! Press F5 to run.")
  end,
}
