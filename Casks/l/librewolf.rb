cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  version "150.0.1,1"
  sha256 arm:   "8f6137859e0af1719ec0e30b6f4307248a3a928d30a848e4a79c5ce2538029fa",
         intel: "453e037a5a05856a913a141c066cb83870cf71257539baa38a6ab60391b8cf13"

  url "https://codeberg.org/api/packages/librewolf/generic/librewolf/150.0.1-1/librewolf-150.0.1-1-macos-#{arch}-package.dmg",
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

  preflight do
    File.write shimscript, <<~EOS
      #!/bin/sh
      exec '#{appdir}/LibreWolf.app/Contents/MacOS/librewolf' "$@"
    EOS
  end

  # Remove quarantine
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/LibreWolf.app"]
  end

  zap trash: [
    "~/.librewolf",
    "~/Library/Application Support/LibreWolf",
    "~/Library/Caches/LibreWolf Community",
    "~/Library/Caches/LibreWolf",
    "~/Library/Preferences/io.gitlab.librewolf-community.librewolf.plist",
    "~/Library/Saved Application State/io.gitlab.librewolf-community.librewolf.savedState",
  ]
end

