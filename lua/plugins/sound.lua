-- ~/.config/nvim/lua/plugins/sound.lua
--
-- Mechvibes CherryMX Black - ABS keycaps sounds for Neovim
-- Requires: EggbertFluffle/beepboop.nvim
-- Place all extracted .ogg files in: ~/.config/nvim/sounds/

local M = {}

-- ── Fallback pool (random letter key sound for unknown chars) ────────────────
local FALLBACK_SOUNDS = {
  "KeyA.ogg",
  "KeyB.ogg",
  "KeyC.ogg",
  "KeyD.ogg",
  "KeyE.ogg",
  "KeyF.ogg",
  "KeyG.ogg",
  "KeyH.ogg",
  "KeyI.ogg",
  "KeyJ.ogg",
  "KeyK.ogg",
  "KeyL.ogg",
  "KeyM.ogg",
  "KeyN.ogg",
  "KeyO.ogg",
  "KeyP.ogg",
  "KeyQ.ogg",
  "KeyR.ogg",
  "KeyS.ogg",
  "KeyT.ogg",
}

-- ── Character → sound file mapping ──────────────────────────────────────────
-- Uppercase letters reuse the same Key*.ogg (same physical key, shift is silent).
-- Every shifted symbol maps to its unshifted key's sound.
local CHAR_TO_SOUND = {
  -- Letters
  a = "KeyA.ogg",
  b = "KeyB.ogg",
  c = "KeyC.ogg",
  d = "KeyD.ogg",
  e = "KeyE.ogg",
  f = "KeyF.ogg",
  g = "KeyG.ogg",
  h = "KeyH.ogg",
  i = "KeyI.ogg",
  j = "KeyJ.ogg",
  k = "KeyK.ogg",
  l = "KeyL.ogg",
  m = "KeyM.ogg",
  n = "KeyN.ogg",
  o = "KeyO.ogg",
  p = "KeyP.ogg",
  q = "KeyQ.ogg",
  r = "KeyR.ogg",
  s = "KeyS.ogg",
  t = "KeyT.ogg",
  u = "KeyU.ogg",
  v = "KeyV.ogg",
  w = "KeyW.ogg",
  x = "KeyX.ogg",
  y = "KeyY.ogg",
  z = "KeyZ.ogg",
  A = "KeyA.ogg",
  B = "KeyB.ogg",
  C = "KeyC.ogg",
  D = "KeyD.ogg",
  E = "KeyE.ogg",
  F = "KeyF.ogg",
  G = "KeyG.ogg",
  H = "KeyH.ogg",
  I = "KeyI.ogg",
  J = "KeyJ.ogg",
  K = "KeyK.ogg",
  L = "KeyL.ogg",
  M = "KeyM.ogg",
  N = "KeyN.ogg",
  O = "KeyO.ogg",
  P = "KeyP.ogg",
  Q = "KeyQ.ogg",
  R = "KeyR.ogg",
  S = "KeyS.ogg",
  T = "KeyT.ogg",
  U = "KeyU.ogg",
  V = "KeyV.ogg",
  W = "KeyW.ogg",
  X = "KeyX.ogg",
  Y = "KeyY.ogg",
  Z = "KeyZ.ogg",

  -- Digits
  ["0"] = "Digit0.ogg",
  ["1"] = "Digit1.ogg",
  ["2"] = "Digit2.ogg",
  ["3"] = "Digit3.ogg",
  ["4"] = "Digit4.ogg",
  ["5"] = "Digit5.ogg",
  ["6"] = "Digit6.ogg",
  ["7"] = "Digit7.ogg",
  ["8"] = "Digit8.ogg",
  ["9"] = "Digit9.ogg",

  -- Shifted digit row
  ["!"] = "Digit1.ogg",
  ["@"] = "Digit2.ogg",
  ["#"] = "Digit3.ogg",
  ["$"] = "Digit4.ogg",
  ["%"] = "Digit5.ogg",
  ["^"] = "Digit6.ogg",
  ["&"] = "Digit7.ogg",
  ["*"] = "Digit8.ogg",
  ["("] = "Digit9.ogg",
  [")"] = "Digit0.ogg",

  -- Space & enter
  [" "] = "Space.ogg",
  ["\r"] = "Enter.ogg",
  ["\n"] = "Enter.ogg",

  -- Punctuation
  ["`"] = "Backquote.ogg",
  ["~"] = "Backquote.ogg",
  ["-"] = "Minus.ogg",
  ["_"] = "Minus.ogg",
  ["="] = "Equal.ogg",
  ["+"] = "Equal.ogg",
  ["["] = "BracketLeft.ogg",
  ["{"] = "BracketLeft.ogg",
  ["]"] = "BracketRight.ogg",
  ["}"] = "BracketRight.ogg",
  ["\\"] = "Backslash.ogg",
  ["|"] = "Backslash.ogg",
  [";"] = "Semicolon.ogg",
  [":"] = "Semicolon.ogg",
  ["'"] = "Quote.ogg",
  ['"'] = "Quote.ogg",
  [","] = "Comma.ogg",
  ["<"] = "Comma.ogg",
  ["."] = "Period.ogg",
  [">"] = "Period.ogg",
  ["/"] = "Slash.ogg",
  ["?"] = "Slash.ogg",
}

-- ── Debounce state ───────────────────────────────────────────────────────────
local MIN_INTERVAL_MS = 30 -- typing: fire every 30ms max
local NAV_INTERVAL_MS = 120 -- held arrow keys: fire every 120ms max (tune to taste)
local last_played_ms = 0
local last_nav_played_ms = 0

-- ── Core play helper ─────────────────────────────────────────────────────────
-- Wrapped in pcall so a bad trigger_name never crashes Neovim.
local function play(trigger_name)
  local ok, bb = pcall(require, "beepboop")
  if not ok then
    return
  end
  pcall(bb.play_audio, trigger_name)
end

-- Like play() but with its own debounce for held navigation keys
local function play_nav(trigger_name)
  local now = vim.loop.now()
  if (now - last_nav_played_ms) < NAV_INTERVAL_MS then
    return
  end
  last_nav_played_ms = now
  play(trigger_name)
end

-- ── InsertCharPre handler ────────────────────────────────────────────────────
function M.on_insert_char()
  local now = vim.loop.now()
  if (now - last_played_ms) < MIN_INTERVAL_MS then
    return
  end
  last_played_ms = now

  local char = vim.v.char
  local sound = CHAR_TO_SOUND[char] or FALLBACK_SOUNDS[math.random(#FALLBACK_SOUNDS)]
  play(sound)
end

-- ── ModeChanged handler ──────────────────────────────────────────────────────
function M.on_mode_changed()
  local new = vim.v.event.new_mode
  if new == "i" or new == "ic" then
    play("Tab.ogg")
  elseif new == "n" then
    play("Escape.ogg")
  elseif new == "v" or new == "V" or new == "\22" then
    play("CapsLock.ogg")
  elseif new == "c" then
    play("Enter.ogg")
  end
end

-- ── Plugin spec ─────────────────────────────────────────────────────────────
return {
  {
    "EggbertFluffle/beepboop.nvim",
    commit = "280bce9f30b2e9d50921bb4a9e104a3c61451685",

    opts = {
      audio_player = "paplay", -- Linux/PulseAudio. macOS: "afplay"
      sound_directory = vim.fn.stdpath("config") .. "/sounds/",
      enable_sound = true,
      volume = 80,
      max_sounds = 8,

      -- ONLY trigger_name registrations here.
      -- No key_map entries for insert-mode keys — those break backspace/enter.
      -- Special keys are handled below with feedkeys so real actions are preserved.
      sound_map = {
        { trigger_name = "KeyA.ogg", sound = "KeyA.ogg" },
        { trigger_name = "KeyB.ogg", sound = "KeyB.ogg" },
        { trigger_name = "KeyC.ogg", sound = "KeyC.ogg" },
        { trigger_name = "KeyD.ogg", sound = "KeyD.ogg" },
        { trigger_name = "KeyE.ogg", sound = "KeyE.ogg" },
        { trigger_name = "KeyF.ogg", sound = "KeyF.ogg" },
        { trigger_name = "KeyG.ogg", sound = "KeyG.ogg" },
        { trigger_name = "KeyH.ogg", sound = "KeyH.ogg" },
        { trigger_name = "KeyI.ogg", sound = "KeyI.ogg" },
        { trigger_name = "KeyJ.ogg", sound = "KeyJ.ogg" },
        { trigger_name = "KeyK.ogg", sound = "KeyK.ogg" },
        { trigger_name = "KeyL.ogg", sound = "KeyL.ogg" },
        { trigger_name = "KeyM.ogg", sound = "KeyM.ogg" },
        { trigger_name = "KeyN.ogg", sound = "KeyN.ogg" },
        { trigger_name = "KeyO.ogg", sound = "KeyO.ogg" },
        { trigger_name = "KeyP.ogg", sound = "KeyP.ogg" },
        { trigger_name = "KeyQ.ogg", sound = "KeyQ.ogg" },
        { trigger_name = "KeyR.ogg", sound = "KeyR.ogg" },
        { trigger_name = "KeyS.ogg", sound = "KeyS.ogg" },
        { trigger_name = "KeyT.ogg", sound = "KeyT.ogg" },
        { trigger_name = "KeyU.ogg", sound = "KeyU.ogg" },
        { trigger_name = "KeyV.ogg", sound = "KeyV.ogg" },
        { trigger_name = "KeyW.ogg", sound = "KeyW.ogg" },
        { trigger_name = "KeyX.ogg", sound = "KeyX.ogg" },
        { trigger_name = "KeyY.ogg", sound = "KeyY.ogg" },
        { trigger_name = "KeyZ.ogg", sound = "KeyZ.ogg" },
        { trigger_name = "Digit0.ogg", sound = "Digit0.ogg" },
        { trigger_name = "Digit1.ogg", sound = "Digit1.ogg" },
        { trigger_name = "Digit2.ogg", sound = "Digit2.ogg" },
        { trigger_name = "Digit3.ogg", sound = "Digit3.ogg" },
        { trigger_name = "Digit4.ogg", sound = "Digit4.ogg" },
        { trigger_name = "Digit5.ogg", sound = "Digit5.ogg" },
        { trigger_name = "Digit6.ogg", sound = "Digit6.ogg" },
        { trigger_name = "Digit7.ogg", sound = "Digit7.ogg" },
        { trigger_name = "Digit8.ogg", sound = "Digit8.ogg" },
        { trigger_name = "Digit9.ogg", sound = "Digit9.ogg" },
        { trigger_name = "Space.ogg", sound = "Space.ogg" },
        { trigger_name = "Enter.ogg", sound = "Enter.ogg" },
        { trigger_name = "Backspace.ogg", sound = "Backspace.ogg" },
        { trigger_name = "Tab.ogg", sound = "Tab.ogg" },
        { trigger_name = "Delete.ogg", sound = "Delete.ogg" },
        { trigger_name = "Escape.ogg", sound = "Escape.ogg" },
        { trigger_name = "CapsLock.ogg", sound = "CapsLock.ogg" },
        { trigger_name = "ArrowUp.ogg", sound = "ArrowUp.ogg" },
        { trigger_name = "ArrowDown.ogg", sound = "ArrowDown.ogg" },
        { trigger_name = "ArrowLeft.ogg", sound = "ArrowLeft.ogg" },
        { trigger_name = "ArrowRight.ogg", sound = "ArrowRight.ogg" },
        { trigger_name = "Home.ogg", sound = "Home.ogg" },
        { trigger_name = "End.ogg", sound = "End.ogg" },
        { trigger_name = "PageUp.ogg", sound = "PageUp.ogg" },
        { trigger_name = "PageDown.ogg", sound = "PageDown.ogg" },
        { trigger_name = "Insert.ogg", sound = "Insert.ogg" },
        { trigger_name = "Backquote.ogg", sound = "Backquote.ogg" },
        { trigger_name = "Minus.ogg", sound = "Minus.ogg" },
        { trigger_name = "Equal.ogg", sound = "Equal.ogg" },
        { trigger_name = "BracketLeft.ogg", sound = "BracketLeft.ogg" },
        { trigger_name = "BracketRight.ogg", sound = "BracketRight.ogg" },
        { trigger_name = "Backslash.ogg", sound = "Backslash.ogg" },
        { trigger_name = "Semicolon.ogg", sound = "Semicolon.ogg" },
        { trigger_name = "Quote.ogg", sound = "Quote.ogg" },
        { trigger_name = "Comma.ogg", sound = "Comma.ogg" },
        { trigger_name = "Period.ogg", sound = "Period.ogg" },
        { trigger_name = "Slash.ogg", sound = "Slash.ogg" },
        { trigger_name = "ShiftLeft.ogg", sound = "ShiftLeft.ogg" },
        { trigger_name = "ShiftRight.ogg", sound = "ShiftRight.ogg" },
        { trigger_name = "ControlLeft.ogg", sound = "ControlLeft.ogg" },
        { trigger_name = "AltLeft.ogg", sound = "AltLeft.ogg" },
        { trigger_name = "F1.ogg", sound = "F1.ogg" },
        { trigger_name = "F2.ogg", sound = "F2.ogg" },
        { trigger_name = "F3.ogg", sound = "F3.ogg" },
        { trigger_name = "F4.ogg", sound = "F4.ogg" },
        { trigger_name = "F5.ogg", sound = "F5.ogg" },
        { trigger_name = "F6.ogg", sound = "F6.ogg" },
        { trigger_name = "F7.ogg", sound = "F7.ogg" },
        { trigger_name = "F8.ogg", sound = "F8.ogg" },
        { trigger_name = "F9.ogg", sound = "F9.ogg" },
        { trigger_name = "F10.ogg", sound = "F10.ogg" },
        { trigger_name = "F11.ogg", sound = "F11.ogg" },
        { trigger_name = "F12.ogg", sound = "F12.ogg" },
        { trigger_name = "NumLock.ogg", sound = "NumLock.ogg" },
        { trigger_name = "ScrollLock.ogg", sound = "ScrollLock.ogg" },
        { trigger_name = "Pause.ogg", sound = "Pause.ogg" },
        { trigger_name = "PrintScreen.ogg", sound = "PrintScreen.ogg" },
        { trigger_name = "Numpad0.ogg", sound = "Numpad0.ogg" },
        { trigger_name = "Numpad1.ogg", sound = "Numpad1.ogg" },
        { trigger_name = "Numpad2.ogg", sound = "Numpad2.ogg" },
        { trigger_name = "Numpad3.ogg", sound = "Numpad3.ogg" },
        { trigger_name = "Numpad4.ogg", sound = "Numpad4.ogg" },
        { trigger_name = "Numpad5.ogg", sound = "Numpad5.ogg" },
        { trigger_name = "Numpad6.ogg", sound = "Numpad6.ogg" },
        { trigger_name = "Numpad7.ogg", sound = "Numpad7.ogg" },
        { trigger_name = "Numpad8.ogg", sound = "Numpad8.ogg" },
        { trigger_name = "Numpad9.ogg", sound = "Numpad9.ogg" },
        { trigger_name = "NumpadAdd.ogg", sound = "NumpadAdd.ogg" },
        { trigger_name = "NumpadSubtract.ogg", sound = "NumpadSubtract.ogg" },
        { trigger_name = "NumpadMultiply.ogg", sound = "NumpadMultiply.ogg" },
        { trigger_name = "NumpadDivide.ogg", sound = "NumpadDivide.ogg" },
        { trigger_name = "NumpadEnter.ogg", sound = "NumpadEnter.ogg" },
        { trigger_name = "NumpadDecimal.ogg", sound = "NumpadDecimal.ogg" },
      },
    },

    config = function(_, opts)
      math.randomseed(os.time())
      require("beepboop").setup(opts)

      -- ── Printable characters in insert mode ──────────────────────────────
      -- InsertCharPre does NOT fire for <BS>/<CR>/<Tab>/<Del> — those need
      -- explicit keymaps below.
      vim.api.nvim_create_autocmd("InsertCharPre", {
        desc = "Mechvibes: play sound for typed character",
        callback = M.on_insert_char,
      })

      -- ── Mode-change sounds ───────────────────────────────────────────────
      vim.api.nvim_create_autocmd("ModeChanged", {
        desc = "Mechvibes: play sound on mode transition",
        callback = M.on_mode_changed,
      })

      -- ── Special insert-mode keys ─────────────────────────────────────────
      -- feedkeys("n") sends the key back through Neovim without re-triggering
      -- our mapping, so the real action (delete char, newline, etc.) still runs.
      local function imap_sound(lhs, sound)
        vim.keymap.set("i", lhs, function()
          play(sound)
          local key = vim.api.nvim_replace_termcodes(lhs, true, false, true)
          vim.api.nvim_feedkeys(key, "n", false)
        end, { desc = "Mechvibes: " .. lhs, silent = true })
      end

      imap_sound("<BS>", "Backspace.ogg")
      imap_sound("<CR>", "Enter.ogg")
      imap_sound("<Tab>", "Tab.ogg")
      imap_sound("<Del>", "Delete.ogg")

      -- ── Normal-mode navigation ───────────────────────────────────────────
      -- play_nav has a longer debounce so held arrow keys don't fire
      -- a sound on every repeat event (bebebebebe → smooth thud).
      local function nmap_sound(lhs, sound)
        vim.keymap.set("n", lhs, function()
          play_nav(sound)
          local key = vim.api.nvim_replace_termcodes(lhs, true, false, true)
          vim.api.nvim_feedkeys(key, "n", false)
        end, { desc = "Mechvibes: " .. lhs, silent = true })
      end

      nmap_sound("<Up>", "ArrowDown.ogg")
      nmap_sound("<Down>", "ArrowDown.ogg")
      nmap_sound("<Left>", "ArrowLeft.ogg")
      nmap_sound("<Right>", "ArrowRight.ogg")
    end,

    keys = {
      {
        "<leader>st",
        function()
          vim.cmd("BeepBoopToggle")
        end,
        desc = "Sound: toggle",
      },
      {
        "<leader>s+",
        function()
          vim.cmd("BeepBoopVolume +10")
        end,
        desc = "Sound: volume up",
      },
      {
        "<leader>s-",
        function()
          vim.cmd("BeepBoopVolume -10")
        end,
        desc = "Sound: volume down",
      },
    },
  },
}
