cask "librewolf" do
  arch arm: "arm64", intel: "x86_64"

  version "153.0.4,1"
  sha256 arm:   "4971d23a262a7414d6d7de2bc0449832a7e39cb341fc3f9b7388fe181fbf24a1",
         intel: "7d856314effa69e6955f1db4b2e94209b30b9b3757f324499db5e3acef0ae609"

  url "https://codeberg.org/api/packages/librewolf/generic/librewolf/153.0.4-1/librewolf-153.0.4-1-macos-#{arch}-package.dmg",
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

