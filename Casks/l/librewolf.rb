cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  version "148.0,1"
  sha256 arm:   "bd26709405f5bae9df8b58f3c09bed96f8d68fcc21ed1b5ca55d8c75bca1879f",
         intel: "e5170f572699292b4be2a26258d71bd796ae586a9e28f148e70cd9cca1538f00"

  url "https://codeberg.org/api/packages/librewolf/generic/librewolf/148.0-1/librewolf-148.0-1-macos-#{arch}-package.dmg",
      verified: "codeberg.org/api/packages/librewolf/generic/librewolf/"
  name "LibreWolf"
  desc "Web browser"
  homepage "https://librewolf.net/"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url "https://codeberg.org/api/v1/repos/librewolf/bsys6/releases/latest"
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :json do |json, regex|
      json["tag_name"]&.[](regex, 1)&.tr("-", ",")
    end
  end

  app "LibreWolf.app"
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/librewolf.wrapper.sh"
  binary shimscript, target: "librewolf"

  launchagent "com.user.akdev1l.librewolf.quaratine.fix.plist"

  preflight do
    File.write shimscript, <<~EOS
      #!/bin/sh
      exec '#{appdir}/LibreWolf.app/Contents/MacOS/librewolf' "$@"
    EOS

    File.write "#{staged_path}/com.user.akdev1l.librewolf.quaratine.fix.plist", <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>com.user.akdev1l.librewolf.quaratine.fix</string>
        <key>ProgramArguments</key>
        <array>
          <string>/usr/bin/xattr</string>
          <string>-dr</string>
          <string>com.apple.quarantine</string>
          <string>#{appdir}/LibreWolf.app</string>
        </array>
        <key>WatchPaths</key>
        <array>
          <string>#{appdir}/LibreWolf.app</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  zap trash: [
    "~/.librewolf",
    "~/Library/Application Support/LibreWolf",
    "~/Library/Caches/LibreWolf Community",
    "~/Library/Caches/LibreWolf",
    "~/Library/Preferences/io.gitlab.librewolf-community.librewolf.plist",
    "~/Library/Saved Application State/io.gitlab.librewolf-community.librewolf.savedState",
    "~/Library/LaunchAgents/com.user.akdev1l.librewolf.quaratine.fix.plist",
  ]
end

