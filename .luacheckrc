-- luacheck configuration to reduce noise for game engine globals and generated folders
std = "lua52"

globals = {
  "Lang",
  "UI",
  "World",
  "CEGUIImageManager",
  "L",
  "imgMgr",
  "UIManager",
  "cdTimer"
}

exclude_files = {
  "smali/**",
  "smali_*",
  "smali_classes*/**",
  "smali_assets/**",
  "lib/**",
  "build/**",
  "original/**",
  "assets/**/resourcesv2/**"
}

-- reduce strictness on redefinitions (often generated or pattern-based)
allow_defined = true
