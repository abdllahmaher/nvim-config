return {
	"xeluxee/competitest.nvim",
	dependencies = "MunifTanjim/nui.nvim",
	config = function()
	require("competitest").setup({
			local_config_file_name = ".competitest.lua",

			floating_border = "rounded",
			floating_border_highlight = "FloatBorder",
			picker_ui = {
				width = 0.2,
				height = 0.3,
				mappings = {
					focus_next = { "j", "<down>", "<Tab>" },
					focus_prev = { "k", "<up>", "<S-Tab>" },
					close = { "<esc>", "<C-c>", "q", "Q" },
					submit = { "<cr>" },
				},
			},
			editor_ui = {
				popup_width = 0.4,
				popup_height = 0.6,
				show_nu = true,
				show_rnu = false,
				normal_mode_mappings = {
					switch_window = { "<space>h", "wl" },
					save_and_close = "<C-s>",
					cancel = { "q", "Q" },
				},
				insert_mode_mappings = {
					switch_window = { "<leader>h", "<C-l>", "<C-i>" },
					save_and_close = "<C-s>",
					cancel = "<C-q>",
				},
			},
			runner_ui = {
				interface = "popup",
				selector_show_nu = false,
				selector_show_rnu = false,
				show_nu = true,
				show_rnu = false,
				mappings = { 
          run_again = "R",
          run_all_again = "<C-r>",
					kill = "K",
					kill_all = "<C-k>",
					view_input = { "i", "I" },
					view_output = { "a", "A" },
					view_stdout = { "o", "O" },
					view_stderr = { "e", "E" },
					toggle_diff = { "d", "D" },
					close = { "q", "Q" },
          switch_window = { "<space>h", "wl" },
				},
				viewer = {
					width = 0.5,
					height = 0.5,
					show_nu = true,
					show_rnu = false,
				},
			},
			popup_ui = {
				total_width = 0.8,
				total_height = 0.8,
				layout = {
					{ 4, "tc" },
					{ 5, { { 1, "so" }, { 1, "si" } } },
					{ 5, { { 1, "eo" }, { 1, "se" } } },
				},
			},
			split_ui = {
				position = "right",
				relative_to_editor = true,
				total_width = 0.3,
				vertical_layout = {
					{ 1, "tc" },
					{ 1, { { 1, "so" }, { 1, "eo" } } },
					{ 1, { { 1, "si" }, { 1, "se" } } },
				},
				total_height = 0.4,
				horizontal_layout = {
					{ 2, "tc" },
					{ 3, { { 1, "so" }, { 1, "si" } } },
					{ 3, { { 1, "eo" }, { 1, "se" } } },
				},
			},

			save_current_file = true,
			save_all_files = false,
			compile_directory = ".",
			compile_command = {
				c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
				cpp = { exec = "g++", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
				rust = { exec = "rustc", args = { "$(FNAME)" } },
				java = { exec = "javac", args = { "$(FNAME)" } },
			},
			running_directory = ".",
			run_command = {
				c = { exec = "./$(FNOEXT)" },
				cpp = { exec = "./$(FNOEXT)" },
				rust = { exec = "./$(FNOEXT)" },
				python = { exec = "python", args = { "$(FNAME)" } },
				java = { exec = "java", args = { "$(FNOEXT)" } },
			},
			multiple_testing = -1,
			maximum_time = 5000,
			output_compare_method = "squish",
			view_output_diff = false,
      start_receiving_persistently_on_setup = true,
			testcases_directory = ".testcases",
			testcases_use_single_file = true,
			testcases_auto_detect_storage = true,
			testcases_single_file_format = "$(FNOEXT).testcases",
			testcases_input_file_format = "$(FNOEXT)_input$(TCNUM).txt",
			testcases_output_file_format = "$(FNOEXT)_output$(TCNUM).txt",

			companion_port = 27122,
			receive_print_message = true,
			template_file = "$(HOME)/git/Problem-Solving/temp.$(FEXT)",
			evaluate_template_modifiers = true,
			date_format = "%c",


received_files_extension = "cpp",

-- All problems go inside ~/Contest

received_contests_directory = function(task)
  -- task.group or task.url contains the contest info
  local url = task.url or ""
  -- Extract contest number from URL like https://codeforces.com/contest/2197
  local contest_code = url:match("/contest/(%d+)") or "UnknownContest"
  -- Return full path inside ~/Contest
  return vim.fn.expand("~") .. "/Contest/" .. contest_code
end,
received_contests_prompt_directory = true,


-- Each problem inside contest folder, named by its problem code
received_contests_problems_path = function(task, ext)
  local url = task.url or ""
  -- Extract contest number
  local contest_code = url:match("/contest/(%d+)") or "UnknownContest"
  -- Extract problem letter/code
  local problem_code = url:match("/problem/([A-Z])$") or task.name:gsub("%s+", "_")
  -- Full path inside contest folder
  return vim.fn.expand("~") .. "/Contest/" .. contest_code .. "/" .. problem_code .. "." .. ext
end,

received_contests_prompt_extension = true,

-- Hide testcases inside each problem folder
testcases_directory = ".testcases",
testcases_use_single_file = true,

-- Automatically open folders when received
open_received_problems = true,
open_received_contests = true,

-- Standalone problem receive (optional)
--
-- received_problems_path = function(task, ext)
--   local url = task.url or ""
--   local code = url:match(".*/problem/([^/]+/[^/]+)$") or task.name
--   code = code:gsub("/", "_")
--   -- Put all single problems inside ~/Contest
--   return vim.fn.expand("~") .. "/Contest/" .. code .. "." .. ext
-- end,
      --

received_problems_path = function(task, ext)
  local url = task.url or ""

  -- If the problem is from a contest, extract contest and problem
  local contest_code = url:match("/contest/(%d+)") or "Standalone"
  local problem_code = url:match("/problem/([A-Z])$") or task.name:gsub("%s+", "_")

  -- Full path inside contest folder (or Standalone if no contest)
  return vim.fn.expand("~") .. "/Contest/" .. contest_code .. "/" .. problem_code .. "." .. ext
end,

received_problems_prompt_path = true,
replace_received_testcases = false,

		})
	end,
}
